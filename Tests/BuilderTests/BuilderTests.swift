import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import BuilderMacros

let testMacros: [String: Macro.Type] = [
    "CustomBuilder": CustomBuilderMacro.self
]

final class BuilderTests: XCTestCase {
    func test_macro_with_one_string_member() {
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
            macros: testMacros
        )
    }

    func test_macro_with_two_string_member() {
        assertMacroExpansion(
            """
            @CustomBuilder
            struct Person {
                let name: String
                let middleName: String
            }
            """,
            expandedSource: """

            struct Person {
                let name: String
                let middleName: String
            }
            struct PersonBuilder {
                var name: String = ""
                var middleName: String = ""

                func build() -> Person {
                    return Person(
                        name: name,
                        middleName: middleName
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
}
