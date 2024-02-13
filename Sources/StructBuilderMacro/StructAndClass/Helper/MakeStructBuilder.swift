//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 13.02.24.
//

import SwiftSyntax

func makeStructBuilder(withStructName structName: TokenSyntax, and structMembers: [StructMember]) -> StructDeclSyntax {
    StructDeclSyntax(name: getStructBuilderName(from: structName)) {
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
