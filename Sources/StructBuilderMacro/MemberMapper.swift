//
//  MemberMapper.swift
//  
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

typealias Member = (identifier: TokenSyntax, type: TypeSyntax)

struct MemberMapper {
    static func mapFrom(members: MemberBlockItemListSyntax) -> [Member] {
        members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter(\.isStoredProperty)
            .filter { !hasStaticModifier($0) }
            .filter { !hasPrivateModifier($0) }
            .compactMap {
                guard let patternBinding = $0.bindings.first else { return nil }
                guard let identifier = getIdentifierFromMember(patternBinding) else { return nil }
                guard let type = getTypeFromMember(patternBinding) else { return nil }
                return (identifier, type)
            }
    }

    private static func getIdentifierFromMember(_ patternBinding: PatternBindingSyntax) -> TokenSyntax? {
        patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier
    }

    private static func getTypeFromMember(_ patternBinding: PatternBindingSyntax) -> TypeSyntax? {
        patternBinding.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type
    }

    private static func hasStaticModifier(_ variable: VariableDeclSyntax) -> Bool {
        variable.modifiers.contains(where: { $0.name.text.contains("static") })
    }

    private static func hasPrivateModifier(_ variable: VariableDeclSyntax) -> Bool {
        variable.modifiers.contains(where: { $0.name.text.contains("private") })
    }
}

// SOURCE: https://github.com/apple/swift-syntax/tree/main/Examples
private extension VariableDeclSyntax {
    /// Determine whether this variable has the syntax of a stored property.
    ///
    /// This syntactic check cannot account for semantic adjustments due to,
    /// e.g., accessor macros or property wrappers.
    var isStoredProperty: Bool {
        if bindings.count != 1 {
            return false
        }

        switch bindings.first!.accessorBlock?.accessors {
        case .none:
            return true

        case .accessors(let accessors):
            for accessor in accessors {
                switch accessor.accessorSpecifier.tokenKind {
                case .keyword(.willSet), .keyword(.didSet):
                    // Observers can occur on a stored property.
                    break

                default:
                    // Other accessors make it a computed property.
                    return false
                }
            }

            return true

        case .getter:
            return false
        }
    }
}
