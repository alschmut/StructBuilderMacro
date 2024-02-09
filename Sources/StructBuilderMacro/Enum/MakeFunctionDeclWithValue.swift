//
//  MakeFunctionDeclWithValue.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeFunctionDeclWithValue(extractedMember: ExtractedMemberWithValue) -> FunctionDeclSyntax {
    makeBuildFunctionDecl(returningType: extractedMember.type) {
        ReturnStmtSyntax(expression:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(baseName: extractedMember.identifier.trimmed),
                    arguments: LabeledExprListSyntax([])
                )
            )
        )
    }
}
