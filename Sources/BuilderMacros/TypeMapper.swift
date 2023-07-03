//
//  TypeMapper.swift
//
//
//  Created by Alexander Schmutz on 03.07.23.
//

import Foundation
import SwiftSyntax

struct TypeMapper {
    static func getDefaultValueFor(type: TypeSyntax) -> ExprSyntax? {
        if type.kind == .optionalType {
            return nil
        } else if type.kind == .arrayType {
            return ExprSyntax(stringLiteral: "[]")
        } else if let defaultValue = mapping[type.trimmedDescription] {
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
