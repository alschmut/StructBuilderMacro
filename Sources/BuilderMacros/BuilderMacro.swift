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
        let members = structDeclaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self)?.bindings.first }
            .compactMap { $0.pattern.as(IdentifierPatternSyntax.self) }

        let identifier = TokenSyntax.identifier(structDeclaration.identifier.text + "Builder")
            .with(\.trailingTrivia, .spaces(1))


        var returnStatement = ReturnStmtSyntax()
        returnStatement.expression = ExprSyntax(FunctionCallExprSyntax(
            calledExpression: IdentifierExprSyntax(identifier: structDeclaration.identifier),
            leftParen: "(\n",
            argumentList: TupleExprElementListSyntax(
                members.map { member in
                    TupleExprElementSyntax(
                        label: member.identifier.text,
                        expression: ExprSyntax(stringLiteral: member.identifier.text)
                    )
                }
            ),
            rightParen: "\n)"
        ))

        let buildFunction = FunctionDeclSyntax(
            identifier: .identifier("build"),
            signature: FunctionSignatureSyntax(
                input: ParameterClauseSyntax(parameterList: FunctionParameterListSyntax([])),
                output: ReturnClauseSyntax(returnType: TypeSyntax(stringLiteral: structDeclaration.identifier.text))
            )
        ) {
            CodeBlockItemListSyntax([
                CodeBlockItemListSyntax.Element(
                    item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(returnStatement))
                )
            ])
        }

        let structureDeclaration = StructDeclSyntax(identifier: identifier, memberBlockBuilder: {
            MemberDeclListSyntax([
                MemberDeclListSyntax.Element(decl: buildFunction)
            ])
        })
        return [DeclSyntax(structureDeclaration)]
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
