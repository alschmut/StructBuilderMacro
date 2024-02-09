//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeStructBuilder(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let structMembers = extractMembersFrom(structDecl.memberBlock.members)

    return StructDeclSyntax(name: getStructBuilderName(from: structDecl.name)) {
        MemberBlockItemListSyntax {
            for structMember in structMembers {
                MemberBlockItemSyntax(decl: makeVariableDecl(structMember: structMember))
            }
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDecl(name: structDecl.name, structMembers: structMembers)
            )
        }
    }
}
