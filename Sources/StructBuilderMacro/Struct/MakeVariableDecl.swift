//
//  MakeVariableDecl.swift
//
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

func makeVariableDecl(member: Member) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: member.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: member.type),
                initializer: getDefaultInitializerClause(type: member.type)
            )
        }
    )
}

private func getDefaultInitializerClause(type: TypeSyntax) -> InitializerClauseSyntax? {
    guard let defaultExpr = TypeMapper.getDefaultValueFor(type: type) else {
        return nil
    }
    return InitializerClauseSyntax(value: defaultExpr)
}
