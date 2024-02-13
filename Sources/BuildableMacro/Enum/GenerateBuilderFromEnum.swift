//
//  GenerateBuilderFromEnum.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func generateBuilderFromEnum(enumDecl: EnumDeclSyntax) throws -> StructDeclSyntax {
    let enumMember = EnumMember(
        identifier: TokenSyntax(stringLiteral: "value"),
        type: TypeSyntax(stringLiteral: enumDecl.name.text),
        value: try getFirstEnumCaseName(from: enumDecl)
    )
    
    return StructDeclSyntax(name: getStructBuilderName(from: enumDecl.name)) {
        MemberBlockItemListSyntax {
            MemberBlockItemSyntax(decl: makeVariableDeclWithValue(enumMember: enumMember))
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDeclWithValue(enumMember: enumMember)
            )
        }
    }
}
