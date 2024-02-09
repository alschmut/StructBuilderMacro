import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct BuildablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BuildableMacro.self
    ]
}

/// Implementation of the `Buildable` macro, which takes a struct declaration
/// and produces a peer struct which implements the builder pattern
///
///     @Buildable
///     struct Person {
///         let name: String
///         let age: Int
///         let address: Address
///     }
///
///  will expand to
///
///     struct Person {
///         let name: String
///         let age: Int
///         let address: Address
///     }
///     struct PersonBuilder {
///         var name: String = ""
///         var age: Int = 0
///         var address: Address = AddressBuilder().build()
///
///         func build() -> Person {
///             return Person(
///                 name: name,
///                 age: age,
///                 address: address
///             )
///         }
///     }
public struct BuildableMacro: PeerMacro {
    public static func expansion<Context, Declaration>(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [SwiftSyntax.DeclSyntax] where Context : SwiftSyntaxMacros.MacroExpansionContext, Declaration : SwiftSyntax.DeclSyntaxProtocol {
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            let structBuilder = makeStructBuilder(structDecl: structDecl)
            return [DeclSyntax(structBuilder)]
        }

        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            let enumBuilder = try makeEnumBuilder(enumDecl: enumDecl)
            return [DeclSyntax(enumBuilder)]
        }

        throw "Macro can only be applied to struct and enum declarations"
    }
}
