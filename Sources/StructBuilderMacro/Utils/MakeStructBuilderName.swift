//
//  MakeStructBuilderName.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import Foundation
import SwiftSyntax

func makeStructBuilderName(from name: TokenSyntax) -> TokenSyntax {
    TokenSyntax.identifier(name.text + "Builder")
        .with(\.trailingTrivia, .spaces(1))
}
