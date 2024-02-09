//
//  MakeEnumBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import Foundation
import SwiftSyntax

typealias MemberWithValue = (identifier: TokenSyntax, type: TypeSyntax, value: TokenSyntax)

func makeEnumBuilder(enumDecl: EnumDeclSyntax) throws -> StructDeclSyntax {
    guard let firstCaseName = enumDecl.memberBlock.members.first?.decl.as(EnumCaseDeclSyntax.self)?.elements.first?.name else {
        throw "Missing enum case"
    }
    let valueVariable = TokenSyntax(stringLiteral: "value")
    let type = TypeSyntax(stringLiteral: enumDecl.name.text)
    let member = MemberWithValue(valueVariable, type, firstCaseName)
    let structIdentifier = makeStructBuilderName(from: enumDecl.name)

    return StructDeclSyntax(name: structIdentifier) {
        MemberBlockItemListSyntax {
            MemberBlockItemSyntax(decl: makeVariableDeclWithValue(member: member))
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDeclForEnum(returningType: type, withValue: valueVariable)
            )
        }
    }
}

private func makeVariableDeclWithValue(member: MemberWithValue) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: member.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: member.type),
                initializer: InitializerClauseSyntax(value: MemberAccessExprSyntax(name: member.value))
            )
        }
    )
}
