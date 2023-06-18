//
//  CanvasCommands.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation
import SwiftUI

protocol CanvasCommand: Command where ControllerT == Canvas { }

class CreateCommand: CanvasCommand {
    var name: String!
    var type: ShapeType!
    var rect: CGRect = .zero
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        // recognize
        let keywords: [PatternFragment] = [.keyword(.create)]
        let identifiers: [PatternFragment] = [.type(.identifier), .type(.identifier)]
        let values: [PatternFragment] = [
            .type(.punctuation("(")),
            .type(.number),
            .type(.punctuation(",")),
            .type(.number),
            .type(.punctuation(")"))
        ]
        var theResult = aTokenizer.matches(pattern: keywords + identifiers + values + values)
        
        // extract
        let _ = aTokenizer.next() // skip "create"
        if let type = aTokenizer.skipTo(type: .identifier) {
            switch type.data {
            case "ellipse":
                self.type = .ellipse
            case "rectangle":
                self.type = .rectangle
            case "line":
                self.type = .line
            default:
                theResult.error = .notImplemented
            }
        } else {
            theResult.error = .notImplemented
        }
        
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
        
        if let w = aTokenizer.skipTo(type: .number), let h = aTokenizer.skipTo(type: .number) {
            let _w = Int(w.data)!
            let _h = Int(h.data)!
            self.rect.size = CGSize(width: _w, height: _h)
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) -> StatusResult<Bool> {
        aController.items.append(CanvasShape(id: name, type: type, boundingBox: rect))
        
        return StatusResult(value: true)
    }
}

class DeleteCommand: CanvasCommand {
    var name: String!
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        // recognize
        var theResult = aTokenizer.matches(pattern: [.keyword(.delete), .type(.identifier)])
        
        // extract
        let _ = aTokenizer.next()
        if let name = aTokenizer.skipTo(type: .identifier) {
            self.name = name.data
        } else {
            theResult.error = .notImplemented
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) -> StatusResult<Bool> {
        aController.items.removeAll { item in
            item.id == name
        }
        
        return StatusResult(value: true)
    }
}

class EditCommand: CanvasCommand {
    var name: String!
    var type: ShapeType!
    var rect: CGRect = .zero
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        // recognize
        let keywords: [PatternFragment] = [.keyword(.edit)]
        let identifiers: [PatternFragment] = [.type(.identifier), .type(.identifier)]
        let values: [PatternFragment] = [
            .type(.punctuation("(")),
            .type(.number),
            .type(.punctuation(",")),
            .type(.number),
            .type(.punctuation(")"))
        ]
        var theResult = aTokenizer.matches(pattern: keywords + identifiers + values + values)
        
        // extract
        let _ = aTokenizer.next()
        if let type = aTokenizer.skipTo(type: .identifier) {
            switch type.data {
            case "ellipse":
                self.type = .ellipse
            case "rectangle":
                self.type = .rectangle
            case "line":
                self.type = .line
            default:
                theResult.error = .notImplemented
            }
        } else {
            theResult.error = .notImplemented
        }
        
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
        
        if let w = aTokenizer.skipTo(type: .number), let h = aTokenizer.skipTo(type: .number) {
            let _w = Int(w.data)!
            let _h = Int(h.data)!
            self.rect.size = CGSize(width: _w, height: _h)
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) -> StatusResult<Bool> {
        let index = aController.items.firstIndex { item in
            item.id == name
        }
        
        guard let index else { return StatusResult(value: false) }
        
        aController.items[index].boundingBox = rect
        
        return StatusResult(value: true)
    }
}

class ColorCommand: CanvasCommand {
    var name: String!
    var color: Color!
    
    static let colorMap: [String: Color] = [
        "blue": .blue,
        "green": .green,
        "red": .red,
        "purple": .purple,
        "orange": .orange,
        "white": .white
    ]
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        // recognize
        let keywords: [PatternFragment] = [.keyword(.color)]
        let identifiers: [PatternFragment] = [.type(.identifier), .type(.identifier)]
        var theResult = aTokenizer.matches(pattern: keywords + identifiers)
        
        // extract
        let _ = aTokenizer.next()
        if let name = aTokenizer.skipTo(type: .identifier) {
            self.name = name.data
        } else {
            theResult.error = .notImplemented
        }
        
        if let color = aTokenizer.skipTo(type: .identifier) {
            if let _color = Self.colorMap[color.data] {
                self.color = _color
            } else {
                theResult.error = .invalidColor
            }
        } else {
            theResult.error = .notImplemented
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) -> StatusResult<Bool> {
        let index = aController.items.firstIndex { item in
            item.id == name
        }
        
        guard let index else { return StatusResult(value: false) }
        
        aController.items[index].color = color
        
        return StatusResult(value: true)
    }
}

class StrokeCommand: CanvasCommand {
    var name: String!
    var stroke: CGFloat!
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        // recognize
        var theResult = aTokenizer.matches(pattern: [.keyword(.stroke), .type(.identifier), .type(.number)])
        
        // extract
        let _ = aTokenizer.next()
        if let name = aTokenizer.skipTo(type: .identifier) {
            self.name = name.data
        } else {
            theResult.error = .notImplemented
        }
        
        if let stroke = aTokenizer.skipTo(type: .number) {
            self.stroke = CGFloat(Int(stroke.data)!)
        } else {
            theResult.error = .notImplemented
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) -> StatusResult<Bool> {
        let index = aController.items.firstIndex { item in
            item.id == name
        }
        
        guard let index else { return StatusResult(value: false) }
        
        aController.items[index].thickness = stroke
        
        return StatusResult(value: true)
    }
}

class ViewCommand: CanvasCommand {
    var name: String!
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        // recognize
        let keywords: [PatternFragment] = [.keyword(.view)]
        let identifiers: [PatternFragment] = [.type(.identifier)]
        var theResult = aTokenizer.matches(pattern: keywords + identifiers)
        
        // extract
        let _ = aTokenizer.next()
        
        if let name = aTokenizer.skipTo(type: .identifier) {
            self.name = name.data
        } else {
            theResult.error = .notImplemented
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) -> StatusResult<Bool> {
        if name == "center" {
            aController.origin = CGPoint(x: 0, y: 0)
            return StatusResult(value: true)
        }
        
        guard let item = aController.items.first(where: { item in
            item.id == name
        }) else {
            return StatusResult(value: false, error: .itemDoesNotExist)
        }
        
        aController.origin.x = -item.boundingBox.midX
        aController.origin.y = -item.boundingBox.midY
        
        return StatusResult(value: true)
    }
}

class CanvasProcessor: CommandProcessor {
    typealias ControllerT = Canvas
    
    private let commands: [any CanvasCommand] = [
        CreateCommand(),
        DeleteCommand(),
        EditCommand(),
        ColorCommand(),
        StrokeCommand(),
        ViewCommand()
    ]
    
    private var chosenCommands: [any CanvasCommand] = []
    
    func recognizes(_ aTokenizer: Tokenizer) -> StatusResult<Bool> {
        var theResult = StatusResult(value: false)
        
        for command in commands {
            aTokenizer.restart()
            
            let tmpResult = command.recognizes(aTokenizer)
            
            guard tmpResult.value else { continue }
            guard tmpResult.error == nil else { continue }
            
            theResult.value = true // if any recognize we recognize
            chosenCommands.append(command)
        }
        
        return theResult
    }
    
    func run(_ aController: ControllerT) -> StatusResult<Bool> {
        for command in chosenCommands {
            let theResult = command.run(aController)
            
            if theResult.error != nil {
                return theResult
            }
        }
        
        return StatusResult(value: true)
    }
}
