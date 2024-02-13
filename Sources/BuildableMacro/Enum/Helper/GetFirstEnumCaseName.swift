//
//  GetFirstEnumCaseName.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func getFirstEnumCaseName(from enumDecl: EnumDeclSyntax) throws -> TokenSyntax {
    let enumCaseDecls = enumDecl.memberBlock.members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
    guard let firstCaseName = enumCaseDecls.first?.elements.first?.name else {
        throw "Missing enum case"
    }
    return firstCaseName
}
