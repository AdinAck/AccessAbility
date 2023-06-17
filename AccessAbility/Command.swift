//
//  CommandProcessor.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation
import SwiftUI

protocol Command {
    associatedtype ControllerT
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool>
    func run(_ aController: ControllerT)
}

protocol CommandProcessor: ObservableObject {
    associatedtype ControllerT
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool>
    func run(_ aController: ControllerT)
}
