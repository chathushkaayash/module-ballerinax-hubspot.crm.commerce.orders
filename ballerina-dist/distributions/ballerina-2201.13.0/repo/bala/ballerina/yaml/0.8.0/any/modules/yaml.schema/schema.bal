// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

public isolated function getJsonSchemaTags() returns map<YAMLTypeConstructor> {
    return {
        "tag:yaml.org,2002:null": {
            kind: STRING,
            construct: constructSimpleNull,
            identity: isolated function(json j) returns boolean => j is (),
            represent: representAsString
        },
        "tag:yaml.org,2002:bool": {
            kind: STRING,
            construct: constructSimpleBool,
            identity: generateIdentityFunction(boolean),
            represent: representAsString
        },
        "tag:yaml.org,2002:int": {
            kind: STRING,
            construct: constructSimpleInteger,
            identity: generateIdentityFunction(int),
            represent: representAsString
        },
        "tag:yaml.org,2002:float": {
            kind: STRING,
            construct: constructSimpleFloat,
            identity: generateIdentityFunction(float),
            represent: representAsString
        }
    };
}

public isolated function getCoreSchemaTags() returns map<YAMLTypeConstructor> {
    return {
        "tag:yaml.org,2002:null": {
            kind: STRING,
            construct: constructNull,
            identity: isolated function(json j) returns boolean => j is (),
            represent: representAsString
        },
        "tag:yaml.org,2002:bool": {
            kind: STRING,
            construct: constructBool,
            identity: generateIdentityFunction(boolean),
            represent: representAsString
        },
        "tag:yaml.org,2002:int": {
            kind: STRING,
            construct: constructInteger,
            identity: generateIdentityFunction(int),
            represent: representAsString
        },
        "tag:yaml.org,2002:float": {
            kind: STRING,
            construct: constructFloat,
            identity: generateIdentityFunction(float),
            represent: representFloat
        }
    };
}
