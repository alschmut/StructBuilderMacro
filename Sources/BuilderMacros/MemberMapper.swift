//
//  MemberMapper.swift
//  
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax

struct MemberMapper {
    static func mapFrom(members: MemberDeclListSyntax) throws -> [Member] {
        return try members.map {
            (try getIdentifierFromMember($0), try getTypeFromMember($0))
        }
    }

    private static func getIdentifierFromMember(_ member: MemberDeclListItemSyntax) throws -> TokenSyntax {
        guard let identifier = member.decl.as(VariableDeclSyntax.self)?.bindings.first?
            .pattern.as(IdentifierPatternSyntax.self)?.identifier
        else { throw "Missing identifier on member" }
        return identifier
    }

    private static func getTypeFromMember(_ member: MemberDeclListItemSyntax) throws -> TypeSyntax {
        guard let type = member.decl.as(VariableDeclSyntax.self)?.bindings.first?
            .typeAnnotation?.as(TypeAnnotationSyntax.self)?.type
        else { throw "Missing type on member" }
        return type
    }
}
