//
//  MakeFunctionDecl.swift
//  
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

func makeFunctionDecl(name: TokenSyntax, structMembers: [StructMember]) -> FunctionDeclSyntax {
    makeBuildFunctionDecl(returningType: TypeSyntax(stringLiteral: name.text)) {
        ReturnStmtSyntax(expression:
            ExprSyntax(
                makeFunctionCallExpr(name: name, structMembers: structMembers)
            )
        )
    }
}

private func makeFunctionCallExpr(name: TokenSyntax, structMembers: [StructMember]) -> FunctionCallExprSyntax{
    FunctionCallExprSyntax(
        calledExpression: DeclReferenceExprSyntax(baseName: name.trimmed),
        leftParen: .leftParenToken(trailingTrivia: Trivia.spaces(4)),
        arguments: makeLabeledExprList(structMembers: structMembers),
        rightParen: .rightParenToken(leadingTrivia: .newline)
    )
}

private func makeLabeledExprList(structMembers: [StructMember]) -> LabeledExprListSyntax {
    LabeledExprListSyntax {
        for structMember in structMembers {
            LabeledExprSyntax(
                leadingTrivia: .newline,
                label: structMember.identifier,
                colon: TokenSyntax(TokenKind.colon, presence: .present),
                expression: ExprSyntax(stringLiteral: structMember.identifier.text)
            )
        }
    }
}
