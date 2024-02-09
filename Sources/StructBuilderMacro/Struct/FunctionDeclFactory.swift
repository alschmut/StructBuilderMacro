//
//  FunctionDeclFactory.swift
//  
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

struct FunctionDeclFactory {
    static func makeFunctionDeclFrom(name: TokenSyntax, members: [Member]) -> FunctionDeclSyntax {
        let buildFunctionReturnStatement = ReturnStmtSyntax(expression:
            ExprSyntax(FunctionCallExprSyntax(
                calledExpression: DeclReferenceExprSyntax(baseName: name.trimmed),
                leftParen: .leftParenToken(trailingTrivia: Trivia.spaces(4)),
                arguments: LabeledExprListSyntax {
                    for member in members {
                        LabeledExprSyntax(
                            leadingTrivia: .newline,
                            label: member.identifier,
                            colon: TokenSyntax(TokenKind.colon, presence: .present),
                            expression: ExprSyntax(stringLiteral: member.identifier.text)
                        )
                    }
                },
                rightParen: .rightParenToken(leadingTrivia: .newline)
            ))
        )
        
        let buildFunctionSignature = FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax([])),
            returnClause: ReturnClauseSyntax(type: TypeSyntax(stringLiteral: name.text))
        )
        
        return FunctionDeclSyntax(name: .identifier("build"), signature: buildFunctionSignature) {
            CodeBlockItemListSyntax {
                CodeBlockItemSyntax(
                    item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(buildFunctionReturnStatement))
                )
            }
        }
    }
}
