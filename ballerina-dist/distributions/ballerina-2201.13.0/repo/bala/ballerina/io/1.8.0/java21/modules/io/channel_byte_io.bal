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
import ballerina/lang.'value;

isolated function channelReadBytes(ReadableChannel readableChannel) returns readonly & byte[]|Error {
    if readableChannel is ReadableByteChannel {
        var result = readableChannel.readAll();
        check readableChannel.close();
        return result;
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected ReadableByteChannel but found a " + 'value:toString(typeof
        readableChannel));
        return e;
    }
}

isolated function channelReadBlocksAsStream(ReadableChannel readableChannel, int blockSize = 4096) returns stream<
Block, Error?>|Error {
    if readableChannel is ReadableByteChannel {
        return readableChannel.blockStream(blockSize);
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected ReadableByteChannel but found a " + 'value:toString(typeof
        readableChannel));
        return e;
    }
}

isolated function channelWriteBytes(WritableChannel writableChannel, byte[] content) returns Error? {
    if writableChannel is WritableByteChannel {
        do {
            _ = check writableChannel.write(content, 0);
            check writableChannel.close();
        } on fail Error err {
            check writableChannel.close();
            return err;
        }
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected WritableByteChannel but found a " + 'value:toString(typeof
        writableChannel));
        return e;
    }
    return;
}

isolated function channelWriteBlocksFromStream(WritableChannel writableChannel, stream<byte[], Error?> byteStream) returns
Error? {
    if writableChannel is WritableByteChannel {
        do {
            record {|byte[] value;|}|Error? block = byteStream.next();
            while block is record {|byte[] value;|} {
                _ = check writableChannel.write(block.value, 0);
                block = byteStream.next();
            }
            check writableChannel.close();
        } on fail Error err {
            check writableChannel.close();
            return err;
        }
    } else {
        TypeMismatchError e = error TypeMismatchError("Expected WritableByteChannel but found a " + 'value:toString(typeof
        writableChannel));
        return e;
    }
    return;
}
