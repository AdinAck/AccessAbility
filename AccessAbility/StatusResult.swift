//
//  StatusResult.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

enum CommandError {
    case notImplemented
}

struct StatusResult<ValueT> {
    let value: ValueT
    let error: CommandError? = nil
}
