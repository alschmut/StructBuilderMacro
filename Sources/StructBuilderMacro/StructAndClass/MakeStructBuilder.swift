//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeStructBuilder(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let structMembers = getStructMembers(structDecl: structDecl)
    return makeStructBuilderFrom(structDecl: structDecl, structMembers: structMembers)
}

private func getStructMembers(structDecl: StructDeclSyntax) -> [StructMember] {
    if let initialiserDecl = getFirstInitialiser(from: structDecl.memberBlock) {
        return extractInitializerMembers(from: initialiserDecl)
    } else {
        return extractMembersFrom(structDecl.memberBlock.members)
    }
}

private func makeStructBuilderFrom(structDecl: StructDeclSyntax, structMembers: [StructMember]) -> StructDeclSyntax {
    StructDeclSyntax(name: getStructBuilderName(from: structDecl.name)) {
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
