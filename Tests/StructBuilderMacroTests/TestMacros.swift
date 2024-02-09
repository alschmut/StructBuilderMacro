//
//  TestMacros.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntaxMacros
import StructBuilderMacro

let testMacros: [String: Macro.Type] = [
    "Buildable": BuildableMacro.self
]
