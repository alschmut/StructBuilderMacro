import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import BuilderMacros

let testBuilderMacros: [String: Macro.Type] = [
    "CustomBuilder": CustomBuilderMacro.self
]

let testStringifyMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self
]

final class BuilderTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @CustomBuilder
            struct Person {
                let name: String
            }
            """,
            expandedSource: """

            struct Person {
                let name: String
            }
            struct PersonBuilder {
                var name: String = ""

                func build() -> Person {
                    return Person(
                        name: name
                    )
                }
            }
            """,
            macros: testBuilderMacros
        )
    }

    func testMacroWithStringLiteral() {
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testStringifyMacros
        )
    }
}
