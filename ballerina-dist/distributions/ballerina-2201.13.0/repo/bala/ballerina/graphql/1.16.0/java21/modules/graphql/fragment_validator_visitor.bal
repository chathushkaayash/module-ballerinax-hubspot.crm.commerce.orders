// Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import graphql.parser;

class FragmentValidatorVisitor {
    *ValidatorVisitor;

    private final ErrorDetail[] errors = [];
    private final map<parser:FragmentNode> usedFragments = {};
    private final map<parser:FragmentNode> fragments;
    private final NodeModifierContext nodeModifierContext;

    isolated function init(map<parser:FragmentNode> fragments, NodeModifierContext nodeModifierContext) {
        self.fragments = fragments;
        self.nodeModifierContext = nodeModifierContext;
    }

    public isolated function visitDocument(parser:DocumentNode documentNode, anydata data = ()) {
        foreach parser:OperationNode operation in documentNode.getOperations() {
            operation.accept(self);
        }
        map<parser:FragmentNode> fragments = {...documentNode.getFragments()};
        foreach [string, parser:FragmentNode] entry in fragments.entries() {
            if !self.usedFragments.hasKey(entry[0]) {
                string message = string `Fragment "${entry[0]}" is never used.`;
                ErrorDetail errorDetail = getErrorDetailRecord(message, entry[1].getLocation());
                self.errors.push(errorDetail);
            }
            _ = fragments.remove(entry[0]);
        }
    }

    public isolated function visitOperation(parser:OperationNode operationNode, anydata data = ()) {
        foreach parser:SelectionNode selection in operationNode.getSelections() {
            selection.accept(self);
        }
    }

    public isolated function visitField(parser:FieldNode fieldNode, anydata data = ()) {
        foreach parser:SelectionNode selection in fieldNode.getSelections() {
            selection.accept(self);
        }
    }

    public isolated function visitArgument(parser:ArgumentNode argumentNode, anydata data = ()) {}

    public isolated function visitFragment(parser:FragmentNode fragmentNode, anydata data = ()) {
        if self.nodeModifierContext.isFragmentWithCycles(fragmentNode) {
            return;
        }
        self.appendNamedFragmentFields(fragmentNode);
        parser:FragmentNode modifiedFragmentNode = self.nodeModifierContext.getModifiedFragmentNode(fragmentNode);
        self.usedFragments[modifiedFragmentNode.getName()] = modifiedFragmentNode;
        foreach parser:SelectionNode selection in modifiedFragmentNode.getSelections() {
            selection.accept(self);
        }
    }

    isolated function appendNamedFragmentFields(parser:FragmentNode fragmentNode) {
        if self.fragments.hasKey(fragmentNode.getName()) {
            parser:FragmentNode actualFragmentNode = self.fragments.get(fragmentNode.getName());
            if !fragmentNode.isInlineFragment() && fragmentNode.getSelections().length() == 0 {
                self.appendFields(actualFragmentNode, fragmentNode);
            }
        } else {
            string message = string `Unknown fragment "${fragmentNode.getName()}".`;
            ErrorDetail errorDetail = getErrorDetailRecord(message, fragmentNode.getLocation());
            self.errors.push(errorDetail);
            self.nodeModifierContext.addUnknownFragment(fragmentNode);
        }
    }

    isolated function appendFields(parser:FragmentNode actualFragmentNode, parser:FragmentNode fragmentNode) {
        parser:SelectionNode[] selections = [...actualFragmentNode.getSelections(), ...fragmentNode.getSelections()];
        parser:DirectiveNode[] directives = [...actualFragmentNode.getDirectives(), ...fragmentNode.getDirectives()];
        parser:FragmentNode modifiedFragmentNode = fragmentNode.modifyWith(selections, directives,
                                                                            actualFragmentNode.getOnType());
        self.nodeModifierContext.addModifiedFragmentNode(fragmentNode, modifiedFragmentNode);
    }

    public isolated function visitDirective(parser:DirectiveNode directiveNode, anydata data = ()) {}

    public isolated function visitVariable(parser:VariableNode variableNode, anydata data = ()) {}

    public isolated function getErrors() returns ErrorDetail[]? {
        return self.errors.length() > 0 ? self.errors : ();
    }
}
