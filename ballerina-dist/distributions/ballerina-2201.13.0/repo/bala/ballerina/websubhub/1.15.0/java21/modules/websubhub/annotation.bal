// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Configuration for a WebSub Hub service.
#
# + leaseSeconds - The period for which the subscription is expected to be active in the `hub`  
# + webHookConfig - HTTP client configurations for subscription/unsubscription intent verification  
# + autoVerifySubscriptionIntent - Configuration to enable or disable automatic subscription intent verification
public type ServiceConfiguration record {|
    int leaseSeconds?;
    ClientConfiguration webHookConfig?;
    boolean autoVerifySubscriptionIntent = false;
|};

# WebSub Hub Configuration for the service.
public annotation ServiceConfiguration ServiceConfig on service;
