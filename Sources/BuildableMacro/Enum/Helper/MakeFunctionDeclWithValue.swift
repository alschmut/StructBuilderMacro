//
//  MakeFunctionDeclWithValue.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeFunctionDeclWithValue(enumMember: EnumMember) -> FunctionDeclSyntax {
    makeBuildFunctionDecl(returningType: enumMember.type) {
        ReturnStmtSyntax(expression:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(baseName: enumMember.identifier.trimmed),
                    arguments: LabeledExprListSyntax([])
                )
            )
        )
    }
}
