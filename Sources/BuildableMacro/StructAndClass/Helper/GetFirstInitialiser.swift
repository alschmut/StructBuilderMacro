//
//  GetFirstInitialiser.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func getFirstInitialiser(from memberBlock: MemberBlockSyntax) -> InitializerDeclSyntax? {
    memberBlock.members
        .compactMap { $0.decl.as(InitializerDeclSyntax.self) }
        .first
}
