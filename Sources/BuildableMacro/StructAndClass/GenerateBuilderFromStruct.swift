//
//  GenerateBuilderFromStruct.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func generateBuilderFromStruct(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let structMembers = getStructMembers(structDecl: structDecl)
    return makeStructBuilder(withStructName: structDecl.name, and: structMembers)
}

private func getStructMembers(structDecl: StructDeclSyntax) -> [StructMember] {
    if let initialiserDecl = getFirstInitialiser(from: structDecl.memberBlock) {
        return extractInitializerMembers(from: initialiserDecl)
    } else {
        return extractMembersFrom(structDecl.memberBlock.members)
    }
}
