//
//  BuildableEnumTests.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableEnumTests: XCTestCase {
    func test_should_create_macro_from_enum() {
        assertMacroExpansion(
            """
            @Buildable
            enum MyEnum {
                case myCase
            }
            """,
            expandedSource: """

            enum MyEnum {
                case myCase
            }

            struct MyEnumBuilder {
                var value: MyEnum = .myCase

                func build() -> MyEnum {
                    return value
                }
            }

            """,
            macros: testMacros
        )
    }
}

