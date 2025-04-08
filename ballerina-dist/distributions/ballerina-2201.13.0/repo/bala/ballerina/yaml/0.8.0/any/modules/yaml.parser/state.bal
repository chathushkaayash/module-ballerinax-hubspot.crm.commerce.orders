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
import yaml.lexer;
import yaml.common;

public class ParserState {
    # Properties for the YAML lines
    string[] lines;
    int numLines;
    int lineIndex = -1;

    # Current token
    lexer:Token currentToken = {token: lexer:DUMMY};

    # Previous YAML token
    lexer:YAMLToken prevToken = lexer:DUMMY;

    # Used to store the token after peeked.
    # Used later when the checkToken method is invoked.
    lexer:Token tokenBuffer = {token: lexer:DUMMY};

    # Lexical analyzer tool for getting the tokens
    lexer:LexerState lexerState = new ();

    boolean expectBlockSequenceValue = false;

    boolean explicitKey = false;

    boolean explicitDoc = false;

    map<string> customTagHandles = {};

    string[] reservedDirectives = [];

    int lastKeyLine = -1;
    int lastExplicitKeyLine = -1;

    boolean isLastExplicitKey = false;

    # YAML version of the document.
    float? yamlVersion = ();

    public boolean directiveDocument = false;

    boolean tagPropertiesInLine = false;

    boolean emptyKey = false;

    boolean indentationProcessed = false;

    common:Event[] eventBuffer = [];

    public isolated function init(string[] lines) returns ParsingError? {
        self.lines = lines;
        self.numLines = lines.length();
        ParsingError? err = self.initLexer();
        if err is ParsingError {
            self.eventBuffer.push({endType: common:STREAM});
        }
    }

    isolated function updateLexerContext(lexer:Context context) {
        self.lexerState.context = context;
    }

    public isolated function getLineNumber() returns int => self.lexerState.lineNumber + 1;

    public isolated function getIndex() returns int => self.lexerState.index;

    # Initialize the lexer with the attributes of a new line.
    #
    # + message - Error message to display when if the initialization fails 
    # + return - An error if it fails to initialize  
    isolated function initLexer(string message = "Unexpected end of stream") returns ParsingError? {
        self.lineIndex += 1;
        string line;

        if self.lineIndex >= self.numLines {
            return generateGrammarError(self, message);
        }
        line = self.lines[self.lineIndex];

        self.explicitDoc = false;
        self.expectBlockSequenceValue = false;
        self.tagPropertiesInLine = false;
        self.lexerState.setLine(line, self.lineIndex);
    }

    isolated function isEndOfFile() returns boolean => self.lineIndex >= self.numLines - 1;
}
