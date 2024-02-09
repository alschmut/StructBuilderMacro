import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct BuildablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BuildableMacro.self
    ]
}

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

        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            let classBuilder = try makeClassBuilder(classDecl: classDecl)
            return [DeclSyntax(classBuilder)]
        }

        throw "Macro can only be applied to struct and enum declarations"
    }
}
