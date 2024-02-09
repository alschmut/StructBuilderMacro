//
//  StructMapper.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import Foundation
import SwiftSyntax

func makeStructBuilder(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let members = MemberMapper.mapFrom(members: structDecl.memberBlock.members)

    let structIdentifier = TokenSyntax.identifier(structDecl.name.text + "Builder")
        .with(\.trailingTrivia, .spaces(1))

    return StructDeclSyntax(name: structIdentifier) {
        MemberBlockItemListSyntax {
            for member in members {
                MemberBlockItemSyntax(decl: VariableDeclFactory.makeVariableDeclFrom(member: member))
            }
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: FunctionDeclFactory.makeFunctionDeclFrom(name: structDecl.name, members: members)
            )
        }
    }
}
