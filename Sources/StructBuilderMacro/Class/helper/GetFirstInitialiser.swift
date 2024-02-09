//
//  GetFirstInitialiser.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func getFirstInitialiser(from classDecl: ClassDeclSyntax) throws -> InitializerDeclSyntax {
    let initialiserDecls = classDecl.memberBlock.members.compactMap { $0.decl.as(InitializerDeclSyntax.self) }
    guard let initialiserDecl = initialiserDecls.first else {
        throw "Missing initialiser"
    }
    return initialiserDecl
}
