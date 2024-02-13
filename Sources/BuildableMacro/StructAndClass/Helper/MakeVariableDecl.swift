//
//  MakeVariableDecl.swift
//
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

func makeVariableDecl(structMember: StructMember) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: structMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: structMember.type),
                initializer: getDefaultInitializerClause(type: structMember.type)
            )
        }
    )
}

private func getDefaultInitializerClause(type: TypeSyntax) -> InitializerClauseSyntax? {
    guard let defaultExpr = getDefaultValueForType(type) else { return nil }
    return InitializerClauseSyntax(value: defaultExpr)
}
