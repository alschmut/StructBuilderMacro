//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import Foundation
import SwiftSyntax

func makeStructBuilder(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let extractedMembers = extractMembersFrom(structDecl.memberBlock.members)
    let structIdentifier = getStructBuilderName(from: structDecl.name)

    return StructDeclSyntax(name: structIdentifier) {
        MemberBlockItemListSyntax {
            for extractedMember in extractedMembers {
                MemberBlockItemSyntax(decl: makeVariableDecl(extractedMember: extractedMember))
            }
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDecl(name: structDecl.name, extractedMembers: extractedMembers)
            )
        }
    }
}
