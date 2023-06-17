//
//  AppProcessor.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

class TestProcessor: CommandProcessor {
    typealias ControllerT = AppModel
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        return StatusResult(value: false)
    }
    
    func run(_ aController: ControllerT) {
        // do nothing
    }
}
