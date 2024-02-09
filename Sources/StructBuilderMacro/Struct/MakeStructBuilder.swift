//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import Foundation
import SwiftSyntax

func makeStructBuilder(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let members = MemberMapper.mapFrom(members: structDecl.memberBlock.members)

    let structIdentifier = makeStructBuilderName(from: structDecl.name)

    return StructDeclSyntax(name: structIdentifier) {
        MemberBlockItemListSyntax {
            for member in members {
                MemberBlockItemSyntax(decl: makeVariableDecl(member: member))
            }
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDecl(name: structDecl.name, members: members)
            )
        }
    }
}
