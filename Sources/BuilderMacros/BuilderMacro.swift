import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

public struct CustomBuilderMacro: PeerMacro {
    public static func expansion<Context, Declaration>(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [SwiftSyntax.DeclSyntax] where Context : SwiftSyntaxMacros.MacroExpansionContext, Declaration : SwiftSyntax.DeclSyntaxProtocol {
        guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
            return []
        }
//        let members = structDeclaration.memberBlock.members
//        let caseDecls = members.compactMap { $0.decl.as(MemberDeclListSyntax.self) }
//        let elements = caseDecls.flatMap { $0.elements }

//        let structKeyword = SyntaxFactory.makeStructKeyword(trailingTrivia: .spaces(1))
//
//        let identifier = SyntaxFactory.makeIdentifier("Example", trailingTrivia: .spaces(1))
//
//        let leftBrace = SyntaxFactory.makeLeftBraceToken()
//        let rightBrace = SyntaxFactory.makeRightBraceToken(leadingTrivia: .newlines(1))
//        let members = MemberDeclBlockSyntax { builder in
//            builder.useLeftBrace(leftBrace)
//            builder.useRightBrace(rightBrace)
//        }
//
//        let structureDeclaration = StructDeclSyntax { builder in
//            builder.useStructKeyword(structKeyword)
//            builder.useIdentifier(identifier)
//            builder.useMembers(members)
//        }
        return ["""
        struct PersonBuilder {
            var name: String = ""

            func build() -> Person {
                return Person(
                    name: name
                )
            }
        }
        """]
    }
}

@main
struct BuilderPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        CustomBuilderMacro.self
    ]
}
