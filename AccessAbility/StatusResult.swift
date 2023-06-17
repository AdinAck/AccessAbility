//
//  StatusResult.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

enum CommandError {
    case notImplemented,
         
         identifierExpected,
         keywordExpected,
         numberExpected,
         punctuationExpected,
    
         unexpectedKeyword(expected: Keyword)
    
    static func fromType(_ aType: TokenType) -> Self? {
        switch aType {
        case .identifier:
            return .identifierExpected
        case .keyword:
            return .keywordExpected
        case .number:
            return .numberExpected
        case .punctuation(_):
            return .punctuationExpected
        }
    }
}

struct StatusResult<ValueT> {
    var value: ValueT
    var error: CommandError? = nil
}

