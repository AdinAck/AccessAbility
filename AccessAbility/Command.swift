//
//  CommandProcessor.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

protocol Command {
    associatedtype ControllerT
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool>
    func run(_ aController: ControllerT) -> StatusResult<Bool>
}

protocol CommandProcessor {
    associatedtype ControllerT
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool>
    func run(_ aController: ControllerT) -> StatusResult<Bool>
}
