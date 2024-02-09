//
//  MakeEnumBuilder.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import Foundation
import SwiftSyntax

func makeEnumBuilder(enumDecl: EnumDeclSyntax) -> EnumDeclSyntax {
    EnumDeclSyntax(name: enumDecl.name, memberBlock: enumDecl.memberBlock)
}
