//
//  VariableDeclFactory.swift
//
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

struct VariableDeclFactory {
    static func makeVariableDeclFrom(member: Member) -> VariableDeclSyntax {
        VariableDeclSyntax(
            bindingKeyword: .keyword(.var),
            bindings: PatternBindingListSyntax {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: member.identifier),
                    typeAnnotation: TypeAnnotationSyntax(type: member.type),
                    initializer: getDefaultInitializerClause(type: member.type)
                )
            }
        )
    }

    private static func getDefaultInitializerClause(type: TypeSyntax) -> InitializerClauseSyntax? {
        guard let defaultExpr = TypeMapper.getDefaultValueFor(type: type) else {
            return nil
        }
        return InitializerClauseSyntax(value: defaultExpr)
    }
}
