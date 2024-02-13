//
//  MakeClassBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeClassBuilder(classDecl: ClassDeclSyntax) throws -> StructDeclSyntax {
    guard let initialiserDecl = getFirstInitialiser(from: classDecl.memberBlock) else {
        throw "Missing initialiser"
    }
    let structMembers = extractInitializerMembers(from: initialiserDecl)

    return makeStructBuilderFrom(structName: classDecl.name, structMembers: structMembers)
}
