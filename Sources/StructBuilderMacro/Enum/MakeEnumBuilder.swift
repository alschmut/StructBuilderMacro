//
//  MakeEnumBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import Foundation
import SwiftSyntax

func makeEnumBuilder(enumDecl: EnumDeclSyntax) throws -> StructDeclSyntax {
    guard let firstCaseName = enumDecl.memberBlock.members.first?.decl.as(EnumCaseDeclSyntax.self)?.elements.first?.name else {
        throw "Missing enum case"
    }

    let structIdentifier = getStructBuilderName(from: enumDecl.name)
    let valueVariable = TokenSyntax(stringLiteral: "value")
    let returningType = TypeSyntax(stringLiteral: enumDecl.name.text)
    let enumMember = EnumMember(
        identifier: valueVariable,
        type: returningType,
        value: firstCaseName
    )

    return StructDeclSyntax(name: structIdentifier) {
        MemberBlockItemListSyntax {
            MemberBlockItemSyntax(decl: makeVariableDeclWithValue(enumMember: enumMember))
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDeclWithValue(enumMember: enumMember)
            )
        }
    }
}
