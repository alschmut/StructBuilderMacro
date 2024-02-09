//
//  MakeVariableDeclWithValue.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeVariableDeclWithValue(enumMember: EnumMember) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: enumMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: enumMember.type),
                initializer: InitializerClauseSyntax(value: MemberAccessExprSyntax(name: enumMember.value))
            )
        }
    )
}
