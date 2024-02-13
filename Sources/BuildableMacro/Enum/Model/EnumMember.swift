//
//  EnumMember.swift
//  
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

struct EnumMember {
    let identifier: TokenSyntax
    let type: TypeSyntax
    let value: TokenSyntax
}
