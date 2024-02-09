//
//  MakeBuildFunctionDecl.swift
//  
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeBuildFunctionDecl(returningType: TypeSyntax, body: () -> ReturnStmtSyntax) -> FunctionDeclSyntax {
    let buildFunctionSignature = FunctionSignatureSyntax(
        parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax([])),
        returnClause: ReturnClauseSyntax(type: returningType)
    )

    return FunctionDeclSyntax(name: .identifier("build"), signature: buildFunctionSignature) {
        CodeBlockItemListSyntax {
            CodeBlockItemSyntax(
                item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(body()))
            )
        }
    }
}
