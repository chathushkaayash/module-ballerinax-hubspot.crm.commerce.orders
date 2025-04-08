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

type patternParamterType string|isolated function (string:Char char) returns boolean;

isolated function patternPrintable(string:Char char) returns boolean {
    int codePoint = char.toCodePointInt();

    return (codePoint >= 32 && codePoint <= 126)
        || (codePoint >= 160 && codePoint <= 55295)
        || (codePoint >= 57344 && codePoint <= 65533)
        || (codePoint >= 65536 && codePoint <= 1114111)
        || codePoint is 9|10|13|133;
}

isolated function patternJson(string:Char char) returns boolean {
    int codePoint = char.toCodePointInt();

    return (codePoint >= 32 && codePoint <= 1114111)
        || codePoint == 9;
}

isolated function patternBom(string:Char char) returns boolean
    => char.toCodePointInt() == 65279;

isolated function patternLineBreak(string:Char char) returns boolean
    => char.toCodePointInt() is 10|13;

isolated function patternWhitespace(string:Char char) returns boolean
    => char is " "|"\t";

isolated function patternDecimal(string:Char char) returns boolean
    => char is "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9";

isolated function patternHexadecimal(string:Char char) returns boolean
    => char is "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"A"|"B"|"C"|"D"|"E"|"F"|"a"|"b"|"c"|"d"|"e"|"f";

isolated function patternWord(string:Char char) returns boolean {
    int codePoint = char.toCodePointInt();

    return (codePoint >= 97 && codePoint <= 122)
        || (codePoint >= 65 && codePoint <= 90)
        || patternDecimal(char)
        || char == "-";
}

isolated function patternFlowIndicator(string:Char char) returns boolean
    => char is ","|"["|"]"|"{"|"}";

isolated function patternIndicator(string:Char char) returns boolean
    => char is "-"|"?"|":"|","|"["|"]"|"{"|"}"|"#"|"&"|"*"|"!"|"|"|">"|"'"|"\""|"%"|"@"|"`";

isolated function patternUri(string:Char char) returns boolean
    => char is "#"|";"|"/"|"?"|":"|"@"|"&"|"="|"+"|"$"|","|"_"|"."|"!"|"~"|"*"|"'"|"("|")"|"["|"]";
