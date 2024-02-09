//
//  GetFirstEnumCaseName.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func getFirstEnumCaseName(from enumDecl: EnumDeclSyntax) throws -> TokenSyntax {
    guard let firstCaseName = enumDecl.memberBlock.members.first?.decl.as(EnumCaseDeclSyntax.self)?.elements.first?.name else {
        throw "Missing enum case"
    }
    return firstCaseName
}
