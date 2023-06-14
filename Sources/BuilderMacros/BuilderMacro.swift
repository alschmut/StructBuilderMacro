import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct BuilderPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CustomBuilderMacro.self
    ]
}

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")


extension String: Error {}

typealias Member = (identifier: TokenSyntax, type: TypeSyntax)

public struct CustomBuilderMacro: PeerMacro {
    public static func expansion<Context, Declaration>(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [SwiftSyntax.DeclSyntax] where Context : SwiftSyntaxMacros.MacroExpansionContext, Declaration : SwiftSyntax.DeclSyntaxProtocol {
        guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
            return []
        }
        let structIdentifier = TokenSyntax.identifier(structDeclaration.identifier.text + "Builder")
            .with(\.trailingTrivia, .spaces(1))

        let members: [Member] = try structDeclaration.memberBlock.members
            .map {
                (
                    try getIdentifierFromMember($0),
                    try getTypeFromMember($0)
                )
            }

        func getIdentifierFromMember(_ member: MemberDeclListItemSyntax) throws -> TokenSyntax {
            guard let identifier = member.decl.as(VariableDeclSyntax.self)?.bindings.first?
                .pattern.as(IdentifierPatternSyntax.self)?.identifier
            else { throw "Missing identifier on member" }
            return identifier
        }

        func getTypeFromMember(_ member: MemberDeclListItemSyntax) throws -> TypeSyntax {
            guard let type = member.decl.as(VariableDeclSyntax.self)?.bindings.first?
                .typeAnnotation?.as(TypeAnnotationSyntax.self)?.type
            else { throw "Missing type on member" }
            return type
        }

        func getMemberVariable(member: Member) -> VariableDeclSyntax {
            VariableDeclSyntax(
                bindingKeyword: .keyword(.var),
                bindings: PatternBindingListSyntax([
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: member.identifier),
                        typeAnnotation: TypeAnnotationSyntax(type: member.type),
                        initializer: InitializerClauseSyntax(value: ExprSyntax(stringLiteral: "\"\""))
                    )
                ])
            )
        }

        let returnStatement = ReturnStmtSyntax(expression:
            ExprSyntax(FunctionCallExprSyntax(
                calledExpression: IdentifierExprSyntax(identifier: structDeclaration.identifier.trimmed),
                leftParen: .leftParenToken(trailingTrivia: .newline.appending(Trivia.spaces(4))),
                argumentList: TupleExprElementListSyntax {
                    for member in members {
                        TupleExprElementSyntax(
                            label: member.identifier.text,
                            expression: ExprSyntax(stringLiteral: member.identifier.text)
                        )
                    }
                },
                rightParen: .rightParenToken(leadingTrivia: .newline)
            ))
        )

        let buildFunction = FunctionDeclSyntax(
            identifier: .identifier("build"),
            signature: FunctionSignatureSyntax(
                input: ParameterClauseSyntax(parameterList: FunctionParameterListSyntax([])),
                output: ReturnClauseSyntax(returnType: TypeSyntax(stringLiteral: structDeclaration.identifier.text))
            ),
            bodyBuilder: {
                CodeBlockItemListSyntax([
                    CodeBlockItemListSyntax.Element(
                        item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(returnStatement))
                    )
                ])
            })

        let structureDeclaration = StructDeclSyntax(identifier: structIdentifier, memberBlockBuilder: {
            MemberDeclListSyntax {
                for member in members {
                    MemberDeclListItemSyntax(decl: getMemberVariable(member: member))
                }
                MemberDeclListItemSyntax(leadingTrivia: .newlines(2), decl: buildFunction)
            }
        })
        return [DeclSyntax(structureDeclaration)]
    }
}
