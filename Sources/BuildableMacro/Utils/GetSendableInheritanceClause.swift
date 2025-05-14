//
//  File.swift
//  Buildable
//
//  Created by Alexander Schmutz on 14.05.25.
//

import SwiftSyntax

func getSendableInheritanceClause(
    original originalInheritanceClause: InheritanceClauseSyntax?
) -> InheritanceClauseSyntax? {
    guard let inheritedSendableType = originalInheritanceClause?.inheritedTypes.first(where: { $0.isSendableIdentifier }) else {
        return nil
    }
    return InheritanceClauseSyntax(
        colon: TokenSyntax.colonToken(leadingTrivia: .spaces(0), trailingTrivia: .space),
        inheritedTypes: InheritedTypeListSyntax([inheritedSendableType])
    )
}

private extension InheritedTypeSyntax {
    var isSendableIdentifier: Bool {
        type.as(IdentifierTypeSyntax.self)?.name.text == "Sendable"
    }
}
