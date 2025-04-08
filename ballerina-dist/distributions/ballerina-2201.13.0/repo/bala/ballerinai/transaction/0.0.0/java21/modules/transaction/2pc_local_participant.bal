// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/log;
import ballerina/lang.'transaction as lang_trx;

# This represents the protocol associated with the coordination type.
#
# + name - protocol name
type LocalProtocol record {
    string name = "";
};

# This represents the protocol associated with the coordination type.

# + name - protocol name
# + url - protocol URL. This URL will have a value only if the participant is remote. If the participant is local,
#         the `protocolFn` will be called
public type RemoteProtocol record {
    string name = "";
    string url = "";
};

type UProtocol LocalProtocol|RemoteProtocol;

type Participant object {

    string participantId;

    function prepare(string protocol) returns [(PrepareResult|error)?, Participant];

    function notify(string action, string? protocolName) returns (NotifyResult|error)?;
};

class LocalParticipant {

    string participantId;
    private TwoPhaseCommitTransaction participatedTxn;
    private LocalProtocol[] participantProtocols;

    function init(string participantId, TwoPhaseCommitTransaction participatedTxn, LocalProtocol[]
        participantProtocols) {
        self.participantId = participantId;
        self.participatedTxn = participatedTxn;
        self.participantProtocols = participantProtocols;
    }

    function prepare(string protocol) returns [(PrepareResult|error)?, Participant] {
        final string participantId = self.participantId;
        int i = 0;
        while ( i < self.participantProtocols.length()) {
            var localProto = self.participantProtocols[i];
            i += 1;
        //TODO: commenting due to a caching issue
        //foreach var localProto in self.participantProtocols {
            if (localProto.name == protocol) {
                log:printDebug("Preparing local participant: " + participantId);
                return [self.prepareMe(self.participatedTxn.transactionId, self.participatedTxn.transactionBlockId),
                self];
            }
        }
        return [(), self];
    }

    function prepareMe(string transactionId, string transactionBlockId) returns PrepareResult|error {
        final string participantId = self.participantId;
        string participatedTxnId = getParticipatedTransactionId(transactionId, transactionBlockId);
        if (!participatedTransactions.hasKey(participatedTxnId)) {
            return error lang_trx:Error(TRANSACTION_UNKNOWN);
        }
        if (self.participatedTxn.state == TXN_STATE_ABORTED) {
            removeParticipatedTransaction(participatedTxnId);
            log:printDebug("Local participant: " + participantId + " aborted");
            return PREPARE_RESULT_ABORTED;
        } else if (self.participatedTxn.state == TXN_STATE_COMMITTED) {
            removeParticipatedTransaction(participatedTxnId);
            return PREPARE_RESULT_COMMITTED;
        } else {
            boolean successful = prepareResourceManagers(transactionId, transactionBlockId);
            if (successful) {
                self.participatedTxn.state = TXN_STATE_PREPARED;
                log:printDebug("Local participant: " + participantId + " prepared");
                return PREPARE_RESULT_PREPARED;
            } else {
                log:printDebug("Local participant: " + participantId + " aborted");
                return PREPARE_RESULT_ABORTED;
            }
        }
    }

    function notify(string action, string? protocolName) returns (NotifyResult|error)? {
        final string participantId = self.participantId;
        final string act = action;
        if (protocolName is string) {
            int i = 0;
            while ( i < self.participantProtocols.length()) {
                var localProto = self.participantProtocols[i];
                i += 1;
            //TODO: commenting due to caching issue;
            //foreach var localProto in self.participantProtocols {
                if (protocolName == localProto.name) {
                    log:printDebug("Notify(" + act + ") local participant: " + participantId);
                    return self.notifyMe(action, self.participatedTxn.transactionBlockId);
                }
            }
        } else {
            NotifyResult|error notifyResult = (action == COMMAND_COMMIT) ? NOTIFY_RESULT_COMMITTED
                                                                         : NOTIFY_RESULT_ABORTED;
            int i = 0;
            while (i < self.participantProtocols.length()) {
                i += 1;
            //TODO: commenting due to caching issue
            //var localProto = self.participantProtocols[i];
            //foreach var localProto in self.participantProtocols {
                var result = self.notifyMe(action, self.participatedTxn.transactionBlockId);
                if (result is error) {
                    notifyResult = result;
                }
                // Else, nothing to do since we have set the notifyResult already
            }
            return notifyResult;
        }
        return (); // No matching protocol
    }

    function notifyMe(string action, string participatedTxnBlockId) returns NotifyResult|error {
        string participatedTxnId = getParticipatedTransactionId(self.participatedTxn.transactionId, participatedTxnBlockId);
        if (action == COMMAND_COMMIT) {
            if (self.participatedTxn.state == TXN_STATE_PREPARED) {
                boolean successful = commitResourceManagers(self.participatedTxn.transactionId, participatedTxnBlockId);
                removeParticipatedTransaction(participatedTxnId);
                if (successful) {
                    return NOTIFY_RESULT_COMMITTED;
                } else {
                    return error lang_trx:Error(NOTIFY_RESULT_FAILED_EOT_STR);
                }
            } else {
                return error lang_trx:Error(NOTIFY_RESULT_NOT_PREPARED_STR);
            }
        } else if (action == COMMAND_ABORT) {
            boolean successful = abortResourceManagers(self.participatedTxn.transactionId, participatedTxnBlockId);
            removeParticipatedTransaction(participatedTxnId);
            if (successful) {
                return NOTIFY_RESULT_ABORTED;
            } else {
               return error lang_trx:Error(NOTIFY_RESULT_FAILED_EOT_STR);
            }
        } else {
            panic error lang_trx:Error("Invalid protocol action:" + action);
        }
    }
}
