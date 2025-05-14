//
//  GenerateBuilderFromClass.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func generateBuilderFromClass(classDecl: ClassDeclSyntax) throws -> StructDeclSyntax {
    guard let initialiserDecl = getFirstInitialiser(from: classDecl.memberBlock) else {
        throw "Missing initialiser"
    }
    return makeStructBuilder(
        structName: classDecl.name,
        inheritanceClause: classDecl.inheritanceClause,
        structMembers: extractInitializerMembers(from: initialiserDecl)
    )
}
