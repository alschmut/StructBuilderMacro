//
//  ExtractInitializerMembers.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func extractInitializerMembers(from initialiserDecl: InitializerDeclSyntax) -> [StructMember] {
    initialiserDecl.signature.parameterClause.parameters
        .compactMap {
            StructMember(identifier: $0.firstName.trimmed, type: $0.type)
        }
}
