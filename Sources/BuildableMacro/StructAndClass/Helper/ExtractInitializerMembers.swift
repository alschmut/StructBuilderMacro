//
//  ExtractInitializerMembers.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func extractInitializerMembers(from initialiserDecl: InitializerDeclSyntax) -> [StructMember] {
    initialiserDecl.signature.parameterClause.parameters.compactMap {
        guard let functionParameter = $0.as(FunctionParameterSyntax.self) else { return nil }
        let identifier = functionParameter.firstName.trimmed
        let type = functionParameter.type
        return StructMember(identifier: identifier, type: type)
    }
}
