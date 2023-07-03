//
//  FunctionDeclFactory.swift
//  
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

struct FunctionDeclFactory {
    static func makeFunctionDeclFrom(structDeclaration: StructDeclSyntax, members: [Member]) -> FunctionDeclSyntax {
        let buildFunctionReturnStatement = ReturnStmtSyntax(expression:
            ExprSyntax(FunctionCallExprSyntax(
                calledExpression: IdentifierExprSyntax(identifier: structDeclaration.identifier.trimmed),
                leftParen: .leftParenToken(trailingTrivia: Trivia.spaces(4)),
                argumentList: TupleExprElementListSyntax {
                    for member in members {
                        TupleExprElementSyntax(
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
            input: ParameterClauseSyntax(parameterList: FunctionParameterListSyntax([])),
            output: ReturnClauseSyntax(returnType: TypeSyntax(stringLiteral: structDeclaration.identifier.text))
        )
        
        return FunctionDeclSyntax(identifier: .identifier("build"), signature: buildFunctionSignature) {
            CodeBlockItemListSyntax {
                CodeBlockItemSyntax(
                    item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(buildFunctionReturnStatement))
                )
            }
        }
    }
}
