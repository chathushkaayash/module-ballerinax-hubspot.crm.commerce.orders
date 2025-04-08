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

isolated function constructSimpleNull(json data) returns json|SchemaError =>
    constructWithRegex(re `null`, data, "null", isolated function(string s) returns json|SchemaError => ());

isolated function constructSimpleBool(json data) returns json|SchemaError =>
    constructWithRegex(re `true|false`, data, "bool",
    isolated function(string s) returns json|SchemaError => common:processTypeCastingError(boolean:fromString(s)));

isolated function constructSimpleInteger(json data) returns json|SchemaError =>
    constructWithRegex(re `-?(0|[1-9][0-9]*)`, data, "int",
    isolated function(string s) returns json|SchemaError => common:processTypeCastingError(int:fromString(s)));

isolated function constructSimpleFloat(json data) returns json|SchemaError =>
    constructWithRegex(re `-?(0|[1-9][0-9]*)(\.[0-9]*)?([eE][-+]?[0-9]+)?`, data, "float",
    isolated function(string s) returns json|SchemaError => common:processTypeCastingError('decimal:fromString(s)));

isolated function constructNull(json data) returns json|SchemaError =>
    constructWithRegex(re `null|Null|NULL|~`, data, "null", isolated function(string s) returns json|SchemaError => ());

isolated function constructBool(json data) returns json|SchemaError =>
    constructWithRegex(re `true|True|TRUE|false|False|FALSE`, data, "bool",
    isolated function(string s) returns json|SchemaError => common:processTypeCastingError(boolean:fromString(s)));

isolated function constructInteger(json data) returns json|SchemaError {
    string value = data.toString();

    if value.length() == 0 {
        return generateError("An integer cannot be empty");
    }

    // Process integers in different base
    if value[0] == "0" && value.length() > 1 {
        match value[1] {
            "o" => { // Cast to an octal integer
                int output = 0;
                int power = 1;
                int length = value.length() - 3;
                foreach int i in 0 ... length {
                    int digit = <int>(check common:processTypeCastingError(int:fromString(value[length + 2 - i])));
                    if digit > 7 || digit < 1 {
                        return generateError(string `Invalid digit '${digit}' for the octal base`);
                    }
                    output += digit * power;
                    power *= 8;
                }
                return output;
            }
            "x" => { // Cast to a hexadecimal integer
                return common:processTypeCastingError(int:fromHexString(value.substring((2))));
            }
        }
    }

    // Cast to a decimal integer
    return constructWithRegex(re `[-+]?[0-9]+`, data, "int",
        isolated function(string s) returns json|SchemaError => common:processTypeCastingError(int:fromString(s)));
}

isolated function constructFloat(json data) returns json|SchemaError {
    string value = data.toString();

    if value.length() == 0 {
        return generateError("An integer cannot be empty");
    }

    // Process the float symbols
    match value[0] {
        "." => {
            match value.substring(1) {
                "nan"|"NAN"|"NaN" => { // Cast to not a number
                    return float:NaN;
                }
                "inf"|"Inf"|"INF" => { // Cast to infinity
                    return float:Infinity;
                }
            }
        }
        "+"|"-" => {
            // Cast to infinity
            if value.substring(2) == "inf" || value.substring(2) == "Inf" || value.substring(2) == "INF"
                && value[1] == "." {
                return value[0] == "-" ? -float:Infinity : float:Infinity;
            }
        }
    }

    // Cast to float numbers
    return constructWithRegex(re `[-+]?(\.[0-9]+|[0-9]+(\.[0-9]*)?)([eE][-+]?[0-9]+)?`, data, "float",
        isolated function(string s) returns json|SchemaError => common:processTypeCastingError('decimal:fromString(s)));
}

isolated function representFloat(json data) returns string {
    if data == -float:Infinity {
        return "-.inf";
    }

    match data {
        'float:Infinity => {
            return ".inf";
        }
        'float:NaN => {
            return ".nan";
        }
        _ => {
            return data.toString();
        }
    }
}
