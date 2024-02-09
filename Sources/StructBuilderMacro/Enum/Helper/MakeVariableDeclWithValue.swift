//
//  MakeVariableDeclWithValue.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeVariableDeclWithValue(extractedMember: ExtractedMemberWithValue) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: extractedMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: extractedMember.type),
                initializer: InitializerClauseSyntax(value: MemberAccessExprSyntax(name: extractedMember.value))
            )
        }
    )
}
