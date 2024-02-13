//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeStructBuilder(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let structMembers = getStructMembers(structDecl: structDecl)
    return makeStructBuilderFrom(structName: structDecl.name, structMembers: structMembers)
}

private func getStructMembers(structDecl: StructDeclSyntax) -> [StructMember] {
    if let initialiserDecl = getFirstInitialiser(from: structDecl.memberBlock) {
        return extractInitializerMembers(from: initialiserDecl)
    } else {
        return extractMembersFrom(structDecl.memberBlock.members)
    }
}

func makeStructBuilderFrom(structName: TokenSyntax, structMembers: [StructMember]) -> StructDeclSyntax {
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
