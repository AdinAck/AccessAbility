//
//  AppProcessor.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

protocol TestCommand: Command where ControllerT == TestModel { }

class SomeTestCommand: TestCommand {
    var name: String!
    
    var rect: CGRect!
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        // recognize
        let keywords: [PatternFragment] = [.keyword(.create)]
        let identifiers: [PatternFragment] = [.type(.identifier)]
        let values: [PatternFragment] = [
            .type(.punctuation("(")),
            .type(.number),
            .type(.punctuation(",")),
            .type(.number),
            .type(.punctuation(")"))
        ]
        var theResult = aTokenizer.matches(pattern: keywords + identifiers + values + values + [.type(.punctuation(";"))])
        
        // extract
        if let name = aTokenizer.skipTo(type: .identifier) {
            self.name = name.data
        } else {
            theResult.error = .notImplemented
        }
        
        if let x = aTokenizer.skipTo(type: .number), let y = aTokenizer.skipTo(type: .number) {
            let _x = Int(x.data)!
            let _y = Int(y.data)!
            self.rect.origin = CGPoint(x: _x, y: _y)
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) {
        aController.testAttr = "Success!!!"
    }
}

class TestProcessor: CommandProcessor {
    typealias ControllerT = TestModel
    
    private let commands: [any TestCommand] = [
        SomeTestCommand()
    ]
    
    private var chosenCommands: [any TestCommand] = []
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        var theResult = StatusResult(value: false)
        
        for command in commands {
            aTokenizer.restart()
            
            theResult = command.recognizes(aTokenizer)
            
            if theResult.error != nil {
                return theResult
            } else if theResult.value {
                chosenCommands.append(command)
                theResult.value = true
            }
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) {
        for command in chosenCommands {
            command.run(aController)
        }
    }
}
