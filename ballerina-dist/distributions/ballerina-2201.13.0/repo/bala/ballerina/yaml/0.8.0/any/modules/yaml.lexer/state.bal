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

public class LexerState {
    # Properties to represent current position 
    public int index = 0;
    public int lineNumber = 0;

    # Line to be lexically analyzed
    public string line = "";

    # Value of the generated token
    string lexeme = "";

    # Current state of the Lexer
    public Context context = LEXER_START;

    # Minimum indentation imposed by the parent nodes
    Indent[] indents = [];

    # Minimum indentation required to the current line
    int indent = -1;

    # Additional indent set by the indentation indicator
    int addIndent = 1;

    # Represent the number of opened flow collections  
    int numOpenedFlowCollections = 0;

    # Store the lexeme if it will be scanned again by the next token
    string lexemeBuffer = "";

    # Flag is enabled after a JSON key is detected.
    # Used to generate mapping value even when it is possible to generate a planar scalar.
    public boolean isJsonKey = false;

    # The lexer is currently processing trailing comments when the flag is set.
    public boolean trailingComment = false;

    # Start index for the mapping value
    int indentStartIndex = -1;

    YAMLToken[] tokensForMappingValue = [];

    public int lastEscapedChar = -1;

    public boolean allowTokensAsPlanar = false;

    # When flag is set, updates the current indent to the indent of the first line
    boolean captureIndent = false;

    boolean enforceMapping = false;

    int tabInWhitespace = -1;

    boolean indentationBreak = false;

    boolean keyDefinedForLine = false;

    public boolean firstLine = true;

    int mappingKeyColumn = -1;

    # Output YAML token
    YAMLToken token = DUMMY;

    Indentation? indentation = ();

    # Peeks the character succeeding after k indexes. 
    # Returns the character after k spots.
    #
    # + k - Number of characters to peek. Default = 0
    # + return - Character at the peek if not null  
    isolated function peek(int k = 0) returns string? {
        if self.index + k >= self.line.length() || self.index + k < 0 {
            return ();
        }
        return self.line[self.index + k];
    }

    # Increment the index of the column by k indexes
    #
    # + k - Number of indexes to forward. Default = 1
    isolated function forward(int k = 1) {
        if self.index + k <= self.line.length() {
            self.index += k;
        }
    }

    isolated function updateStartIndex(YAMLToken? token = ()) {
        if token != () {
            self.tokensForMappingValue.push(token);
        }
        if self.index < self.indentStartIndex || self.indentStartIndex < 0 {
            self.indentStartIndex = self.index;
        }
    }

    isolated function updateFirstTabIndex() {
        if self.index < self.tabInWhitespace || self.tabInWhitespace < 0 {
            self.tabInWhitespace = self.index;
        }
    }

    # Add the output YAML token to the current state
    #
    # + token - YAML token
    # + return - Generated lexical token  
    isolated function tokenize(YAMLToken token) returns LexerState {
        self.forward();
        self.token = token;
        return self;
    }

    # Obtain the lexer token
    #
    # + return - Lexer token
    public isolated function getToken() returns Token {
        YAMLToken tokenBuffer = self.token;
        self.token = DUMMY;
        string lexemeBuffer = self.lexeme;
        self.lexeme = "";
        Indentation? indentationBuffer = self.indentation;
        self.indentation = ();
        return {
            token: tokenBuffer,
            value: lexemeBuffer,
            indentation: indentationBuffer
        };
    }

    public isolated function setLine(string line, int lineNumber) {
        self.index = 0;
        self.line = line;
        self.lineNumber = lineNumber;
        self.lastEscapedChar = -1;
        self.indentStartIndex = -1;
        self.tokensForMappingValue = [];
        self.tabInWhitespace = -1;
        self.keyDefinedForLine = false;
    }

    # Reset the current lexer state
    public isolated function resetState() {
        self.addIndent = 1;
        self.captureIndent = false;
        self.enforceMapping = false;
        self.indentStartIndex = -1;
        self.indent = -1;
        self.indents = [];
        self.lexeme = "";
        self.context = LEXER_START;
    }

    public isolated function isFlowCollection() returns boolean => self.numOpenedFlowCollections > 0;
    
    # Check if the current character is a new line. 
    # This should be replaced by the os module once it supports an API: #4931.
    # 
    # + return - True if the current character is a new line
    public isolated function isNewLine() returns boolean => self.peek() == "\n" || self.peek() == "\r\n";
}
