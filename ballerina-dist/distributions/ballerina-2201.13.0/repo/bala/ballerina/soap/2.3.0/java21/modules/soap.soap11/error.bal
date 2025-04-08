// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

# Defines the common error type for the SOAP 1.1 module.
public type Error distinct error;

const SOAP_RESPONSE_ERROR = "Failed to create SOAP response";
const SOAP_CLIENT_ERROR = "Failed to initialize SOAP 1.1 client";
const SOAP_ERROR = "Error occurred while executing the API";
const INVALID_OUTBOUND_SECURITY_ERROR = "Outbound security configurations do not match with the SOAP response";
