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

import yaml.common;

# Represents an error caused regarding YAML schema.
public type SchemaError ConstructionError|common:ConversionError;

# Represents an error caused when constructing a Ballerina data type.
public type ConstructionError distinct error;

# Generates a Type Error.
#
# + message - Error message details
# + return - Constructed Type Error message
isolated function generateError(string message) returns ConstructionError => error(message);
