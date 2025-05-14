//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 13.02.24.
//

import SwiftSyntax

func makeStructBuilder(
    structName: TokenSyntax,
    inheritanceClause: InheritanceClauseSyntax?,
    structMembers: [StructMember]
) -> StructDeclSyntax {
    StructDeclSyntax(
        name: getStructBuilderName(from: structName),
        inheritanceClause: getSendableInheritanceClause(original: inheritanceClause)
    ) {
        MemberBlockItemListSyntax {
            for structMember in structMembers {
                MemberBlockItemSyntax(decl: makeVariableDecl(structMember: structMember))
            }
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDecl(name: structName, structMembers: structMembers)
            )
        }
    }
}
