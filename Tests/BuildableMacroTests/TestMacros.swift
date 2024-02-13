//
//  TestMacros.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntaxMacros
import BuildableMacro

let testMacros: [String: Macro.Type] = [
    "Buildable": BuildableMacroType.self
]
