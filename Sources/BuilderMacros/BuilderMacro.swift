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
                bindings: PatternBindingListSyntax {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: member.identifier),
                        typeAnnotation: TypeAnnotationSyntax(type: member.type),
                        initializer: InitializerClauseSyntax(value: TypeMapper.getDefaultValueFor(type: member.type))
                    )
                }
            )
        }

        let buildFunctionReturnStatement = ReturnStmtSyntax(expression:
            ExprSyntax(FunctionCallExprSyntax(
                calledExpression: IdentifierExprSyntax(identifier: structDeclaration.identifier.trimmed),
                leftParen: .leftParenToken(trailingTrivia: Trivia.spaces(4)),
                argumentList: TupleExprElementListSyntax {
                    for member in members {
                        TupleExprElementSyntax(
                            leadingTrivia: .newline,
                            label: member.identifier,
                            colon: TokenSyntax(TokenKind.colon, presence: .present),
                            expression: ExprSyntax(stringLiteral: member.identifier.text)
                        )
                    }
                },
                rightParen: .rightParenToken(leadingTrivia: .newline)
            ))
        )

        let buildFunctionSignature = FunctionSignatureSyntax(
            input: ParameterClauseSyntax(parameterList: FunctionParameterListSyntax([])),
            output: ReturnClauseSyntax(returnType: TypeSyntax(stringLiteral: structDeclaration.identifier.text))
        )

        let buildFunction = FunctionDeclSyntax(identifier: .identifier("build"), signature: buildFunctionSignature) {
            CodeBlockItemListSyntax {
                CodeBlockItemSyntax(
                    item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(buildFunctionReturnStatement))
                )
            }
        }

        let structureDeclaration = StructDeclSyntax(identifier: structIdentifier) {
            MemberDeclListSyntax {
                for member in members {
                    MemberDeclListItemSyntax(decl: getMemberVariable(member: member))
                }
                MemberDeclListItemSyntax(leadingTrivia: .newlines(2), decl: buildFunction)
            }
        }
        return [DeclSyntax(structureDeclaration)]
    }
}

struct TypeMapper {
    static func getDefaultValueFor(type: TypeSyntax) -> ExprSyntax {
        if let defaultValue = mapping[type.trimmedDescription] {
            return defaultValue
        } else {
            return ExprSyntax(stringLiteral: type.trimmedDescription + "Builder().build()")
        }
    }

    private static var mapping: [String: ExprSyntax] = [
        "String": "\"\"",
        "Int": "0",
        "Int8": "0",
        "Int16": "0",
        "Int32": "0",
        "Int46": "0",
        "UInt": "0",
        "UInt8": "0",
        "UInt16": "0",
        "UInt32": "0",
        "UInt46": "0",
        "Bool": "false",
        "Double": "0",
        "Float": "0",
        "Date": ".now",
        "UUID": "UUID()",
        "Data": "Data()",
        "URL": "URL(string: \"https:www.google.com\")",
        "CGFloat": "0",
        "CGPoint": "CGPoint()",
        "CGRect": "CGRect()",
        "CGSize": "CGSize()",
        "CGVector": "CGVector()",
    ]
}

import Foundation
