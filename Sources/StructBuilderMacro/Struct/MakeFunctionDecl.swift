//
//  MakeFunctionDecl.swift
//  
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

func makeFunctionDecl(name: TokenSyntax, extractedMembers: [ExtractedMember]) -> FunctionDeclSyntax {
    makeBuildFunctionDecl(returningType: TypeSyntax(stringLiteral: name.text)) {
        ReturnStmtSyntax(expression:
            ExprSyntax(
                makeFunctionCallExpr(name: name, extractedMembers: extractedMembers)
            )
        )
    }
}

private func makeFunctionCallExpr(name: TokenSyntax, extractedMembers: [ExtractedMember]) -> FunctionCallExprSyntax{
    FunctionCallExprSyntax(
        calledExpression: DeclReferenceExprSyntax(baseName: name.trimmed),
        leftParen: .leftParenToken(trailingTrivia: Trivia.spaces(4)),
        arguments: makeLabeledExprList(extractedMembers: extractedMembers),
        rightParen: .rightParenToken(leadingTrivia: .newline)
    )
}

private func makeLabeledExprList(extractedMembers: [ExtractedMember]) -> LabeledExprListSyntax {
    LabeledExprListSyntax {
        for extractedMember in extractedMembers {
            LabeledExprSyntax(
                leadingTrivia: .newline,
                label: extractedMember.identifier,
                colon: TokenSyntax(TokenKind.colon, presence: .present),
                expression: ExprSyntax(stringLiteral: extractedMember.identifier.text)
            )
        }
    }
}
