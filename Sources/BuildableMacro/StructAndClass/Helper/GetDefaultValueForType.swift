//
//  GetDefaultValueForType.swift
//
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

func getDefaultValueForType(_ type: TypeSyntax) -> ExprSyntax? {
    if type.kind == .optionalType {
        return nil
    } else if type.kind == .implicitlyUnwrappedOptionalType {
        return nil
    } else if type.kind == .dictionaryType {
        return ExprSyntax(stringLiteral: "[:]")
    } else if type.kind == .arrayType {
        return ExprSyntax(stringLiteral: "[]")
    } else if let defaultValue = mapping[type.trimmedDescription] {
        return defaultValue
    } else if let functionType = type.as(FunctionTypeSyntax.self) {
        return ExprSyntax(
            ClosureExprSyntax(
                signature: defaultClosureSignature(withParameterCount: functionType.parameters.count),
                statements: closureCodeBlock(typeSyntax: functionType.returnClause.type)
            )
        )
    } else {
        return ExprSyntax(stringLiteral: type.trimmedDescription + "Builder().build()")
    }
}

private func defaultClosureSignature(
    withParameterCount parameterCount: Int
) -> ClosureSignatureSyntax? {
    guard parameterCount > 0 else {
        return nil
    }
    return ClosureSignatureSyntax(
        parameterClause: ClosureSignatureSyntax.ParameterClause(
            ClosureShorthandParameterListSyntax {
                for _ in 0 ..< parameterCount {
                    ClosureShorthandParameterSyntax(name: "_")
                }
            }
        )
    )
}

private func closureCodeBlock(
    typeSyntax: TypeSyntax
) -> CodeBlockItemListSyntax {
    if typeSyntax.as(IdentifierTypeSyntax.self)?.name.text == "Void"  {
        return CodeBlockItemListSyntax()
    } else {
        return CodeBlockItemListSyntax {
            CodeBlockItemSyntax(
                item: CodeBlockItemSyntax.Item(
                    ReturnStmtSyntax(
                        expression: getDefaultValueForType(typeSyntax)
                    )
                )
            )
        }
    }
}

private var mapping: [String: ExprSyntax] = [
    "String": "\"\"",
    "Int": "0",
    "Int8": "0",
    "Int16": "0",
    "Int32": "0",
    "Int64": "0",
    "UInt": "0",
    "UInt8": "0",
    "UInt16": "0",
    "UInt32": "0",
    "UInt64": "0",
    "Bool": "false",
    "Double": "0",
    "Float": "0",
    "Date": "Date()",
    "UUID": "UUID()",
    "Data": "Data()",
    "URL": "URL(string: \"https://www.google.com\")!",
    "CGFloat": "0",
    "CGPoint": "CGPoint()",
    "CGRect": "CGRect()",
    "CGSize": "CGSize()",
    "CGVector": "CGVector()",
]
