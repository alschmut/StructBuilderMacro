//
//  MakeClassBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeClassBuilder(classDecl: ClassDeclSyntax) throws -> StructDeclSyntax {
    let initialiserDecl = try getFirstInitialiser(from: classDecl)
    let structMembers = extractInitializerMembers(from: initialiserDecl)

    return StructDeclSyntax(name: getStructBuilderName(from: classDecl.name)) {
        MemberBlockItemListSyntax {
            for structMember in structMembers {
                MemberBlockItemSyntax(decl: makeVariableDecl(structMember: structMember))
            }
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDecl(name: classDecl.name, structMembers: structMembers)
            )
        }
    }
}
