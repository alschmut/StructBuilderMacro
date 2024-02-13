//
//  BuildableClassTests.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableClassTests: XCTestCase {
    func test_should_create_macro_from_class() {
        assertMacroExpansion(
            """
            @Buildable
            class MyClass {
                let m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }
            """,
            expandedSource: """

            class MyClass {
                let m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }

            struct MyClassBuilder {
                var m1: String = ""

                func build() -> MyClass {
                    return MyClass(
                        m1: m1
                    )
                }
            }

            """,
            macros: testMacros
        )
    }

    func test_should_create_macro_from_class_with_various_default_values() {
        assertMacroExpansion(
            """
            @Buildable
            class MyClass {
                let m1: String
                let m2: Address
                let m3: String?
                let m4: String!
                let m5: [String]

                init(
                    firstName m1: String,
                    m2: Address = Address(),
                    m3: String?,
                    m4: String!,
                    m5: [String]
                ) {
                    self.m1 = m1
                    self.m2 = m2
                    self.m3 = m3
                    self.m4 = m4
                    self.m5 = m5
                }
            }
            """,
            expandedSource: """

            class MyClass {
                let m1: String
                let m2: Address
                let m3: String?
                let m4: String!
                let m5: [String]

                init(
                    firstName m1: String,
                    m2: Address = Address(),
                    m3: String?,
                    m4: String!,
                    m5: [String]
                ) {
                    self.m1 = m1
                    self.m2 = m2
                    self.m3 = m3
                    self.m4 = m4
                    self.m5 = m5
                }
            }

            struct MyClassBuilder {
                var firstName: String = ""
                var m2: Address = AddressBuilder().build()
                var m3: String?
                var m4: String!
                var m5: [String] = []

                func build() -> MyClass {
                    return MyClass(
                        firstName: firstName,
                        m2: m2,
                        m3: m3,
                        m4: m4,
                        m5: m5
                    )
                }
            }

            """,
            macros: testMacros
        )
    }

    func test_should_set_use_first_found_initializer() {
        assertMacroExpansion(
            """
            @Buildable
            class MyClass {
                let m1: String

                var someValue: String? { nil }

                init(
                    m1: String!,
                ) {
                    self.m1 = m1
                }

                init(
                    m1: String,
                    unusedValue: String
                ) {
                    self.m1 = m1
                }
            }
            """,
            expandedSource: """

            class MyClass {
                let m1: String

                var someValue: String? { nil }

                init(
                    m1: String!,
                ) {
                    self.m1 = m1
                }

                init(
                    m1: String,
                    unusedValue: String
                ) {
                    self.m1 = m1
                }
            }

            struct MyClassBuilder {
                var m1: String!

                func build() -> MyClass {
                    return MyClass(
                        m1: m1
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
}

