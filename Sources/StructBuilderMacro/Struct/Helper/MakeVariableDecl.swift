//
//  MakeVariableDecl.swift
//
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

func makeVariableDecl(extractedMember: ExtractedMember) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: extractedMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: extractedMember.type),
                initializer: getDefaultInitializerClause(type: extractedMember.type)
            )
        }
    )
}

private func getDefaultInitializerClause(type: TypeSyntax) -> InitializerClauseSyntax? {
    guard let defaultExpr = getDefaultValueForType(type) else { return nil }
    return InitializerClauseSyntax(value: defaultExpr)
}
