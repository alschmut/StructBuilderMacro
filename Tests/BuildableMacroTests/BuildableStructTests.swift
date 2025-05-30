//
//  BuildableEnumTests.swift
//
//
//  Created by Alexander Schmutz on 13.06.23.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableStructTests: XCTestCase {
    func test_should_create_builder_with_one_string_member() {
        assertMacroExpansion(
            """
            @Buildable
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

    func test_should_create_builder_with_two_string_members() {
        assertMacroExpansion(
            """
            @Buildable
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

    func test_should_create_builder_with_optional_types() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: String?
                let m2: [Int]?
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: String?
                let m2: [Int]?
            }

            struct MyObjectBuilder {
                var m1: String?
                var m2: [Int]?

                func build() -> MyObject {
                    return MyObject(
                        m1: m1,
                        m2: m2
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_set_default_value_to_custom_type_builder() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: MyOtherObject
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: MyOtherObject
            }

            struct MyObjectBuilder {
                var m1: MyOtherObject = MyOtherObjectBuilder().build()

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_set_default_value_to_empty_collection() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: [String]
                let m2: [MyOtherObject]
                let m3: [String: String]
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: [String]
                let m2: [MyOtherObject]
                let m3: [String: String]
            }

            struct MyObjectBuilder {
                var m1: [String] = []
                var m2: [MyOtherObject] = []
                var m3: [String: String] = [:]

                func build() -> MyObject {
                    return MyObject(
                        m1: m1,
                        m2: m2,
                        m3: m3
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_set_default_value_to_nil_for_implicitly_unwrapped_optional() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: String!
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: String!
            }

            struct MyObjectBuilder {
                var m1: String!

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }
            """,
            macros: testMacros
        )
    }


    func test_should_ignore_computed_variable() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                var unwantedComputedVariable: String {
                    "myText"
                }
            }
            """,
            expandedSource: """

            struct MyObject {
                var unwantedComputedVariable: String {
                    "myText"
                }
            }

            struct MyObjectBuilder {

                func build() -> MyObject {
                    return MyObject(
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_ignore_static_variable() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                static let unwantedStaticVariable1: String = ""
                static var unwantedStaticVariable2: String = ""
            }
            """,
            expandedSource: """

            struct MyObject {
                static let unwantedStaticVariable1: String = ""
                static var unwantedStaticVariable2: String = ""
            }

            struct MyObjectBuilder {

                func build() -> MyObject {
                    return MyObject(
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_ignore_private_variables() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: String?
                private var m2: String?
                public var m3: String?
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: String?
                private var m2: String?
                public var m3: String?
            }

            struct MyObjectBuilder {
                var m1: String?
                var m3: String?

                func build() -> MyObject {
                    return MyObject(
                        m1: m1,
                        m3: m3
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_ignore_constant_variables() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: String?
                let myConstant: String = ""
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: String?
                let myConstant: String = ""
            }

            struct MyObjectBuilder {
                var m1: String?

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_ignore_members_with_accessors() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: String
                var m2: String {
                    get {
                        m1
                    }
                    set {
                        m1 = newValue
                    }
                }
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: String
                var m2: String {
                    get {
                        m1
                    }
                    set {
                        m1 = newValue
                    }
                }
            }

            struct MyObjectBuilder {
                var m1: String = ""

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_set_default_value_for_closures() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: (() -> String)?
                let m2: () -> Void
                let m3: (String) -> Void
                let m4: (String, Int) -> Void
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: (() -> String)?
                let m2: () -> Void
                let m3: (String) -> Void
                let m4: (String, Int) -> Void
            }

            struct MyObjectBuilder {
                var m1: (() -> String)?
                var m2: () -> Void = {
                }
                var m3: (String) -> Void = { _ in
                }
                var m4: (String, Int) -> Void = { _, _ in
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1,
                        m2: m2,
                        m3: m3,
                        m4: m4
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_set_default_value_for_closures_with_return_type() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m1: () -> String
            }
            """,
            expandedSource: """

            struct MyObject {
                let m1: () -> String
            }

            struct MyObjectBuilder {
                var m1: () -> String = {
                    return ""
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_make_struct_sendable() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject: Sendable {
                let m1: () -> String
            }
            """,
            expandedSource: """

            struct MyObject: Sendable {
                let m1: () -> String
            }

            struct MyObjectBuilder : Sendable {
                var m1: () -> String = {
                    return ""
                }

                func build() -> MyObject {
                    return MyObject(
                        m1: m1
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_set_default_value_for_defined_types() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyObject {
                let m01: String
                let m02: Int
                let m03: Int8
                let m04: Int16
                let m05: Int32
                let m06: Int64
                let m07: UInt
                let m08: UInt8
                let m09: UInt16
                let m10: UInt32
                let m11: UInt64
                let m12: Bool
                let m13: Double
                let m14: Float
                let m15: Date
                let m16: UUID
                let m17: Data
                let m18: URL
                let m19: CGFloat
                let m20: CGPoint
                let m21: CGRect
                let m22: CGSize
                let m23: CGVector
            }
            """,
            expandedSource: """

            struct MyObject {
                let m01: String
                let m02: Int
                let m03: Int8
                let m04: Int16
                let m05: Int32
                let m06: Int64
                let m07: UInt
                let m08: UInt8
                let m09: UInt16
                let m10: UInt32
                let m11: UInt64
                let m12: Bool
                let m13: Double
                let m14: Float
                let m15: Date
                let m16: UUID
                let m17: Data
                let m18: URL
                let m19: CGFloat
                let m20: CGPoint
                let m21: CGRect
                let m22: CGSize
                let m23: CGVector
            }
            
            struct MyObjectBuilder {
                var m01: String = ""
                var m02: Int = 0
                var m03: Int8 = 0
                var m04: Int16 = 0
                var m05: Int32 = 0
                var m06: Int64 = 0
                var m07: UInt = 0
                var m08: UInt8 = 0
                var m09: UInt16 = 0
                var m10: UInt32 = 0
                var m11: UInt64 = 0
                var m12: Bool = false
                var m13: Double = 0
                var m14: Float = 0
                var m15: Date = Date()
                var m16: UUID = UUID()
                var m17: Data = Data()
                var m18: URL = URL(string: "https://www.google.com")!
                var m19: CGFloat = 0
                var m20: CGPoint = CGPoint()
                var m21: CGRect = CGRect()
                var m22: CGSize = CGSize()
                var m23: CGVector = CGVector()

                func build() -> MyObject {
                    return MyObject(
                        m01: m01,
                        m02: m02,
                        m03: m03,
                        m04: m04,
                        m05: m05,
                        m06: m06,
                        m07: m07,
                        m08: m08,
                        m09: m09,
                        m10: m10,
                        m11: m11,
                        m12: m12,
                        m13: m13,
                        m14: m14,
                        m15: m15,
                        m16: m16,
                        m17: m17,
                        m18: m18,
                        m19: m19,
                        m20: m20,
                        m21: m21,
                        m22: m22,
                        m23: m23
                    )
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_should_use_members_from_initializer() {
        assertMacroExpansion(
            """
            @Buildable
            struct MyClass {
                let m1: String
                var unused: String = ""

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }
            """,
            expandedSource: """

            struct MyClass {
                let m1: String
                var unused: String = ""

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
}
