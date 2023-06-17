//
//  Tokenizer.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

enum TokenType: Hashable {
    case identifier,
         keyword,
         number,
         punctuation(String)
}

enum Keyword: String {
    case create,
         edit,
         delete,
         select
}

struct Token: CustomStringConvertible {
    let data: String
    let type: TokenType
    let keyword: Keyword?
    
    var description: String {
        return "data: \"\(data)\"\ttype: \(type)\tkeyword: \(keyword == nil ? "N/A" : keyword!.rawValue)"
    }
}

enum PatternFragment {
    case type(TokenType),
         keyword(Keyword)
        
}

enum Pointer {
    case start, end
}

class Scanner {
    private let buffer:   String
    
    private var startPtr: Int  = 0
    private var endPtr:   Int  = 0
    
    fileprivate var eof:      Bool = false
    
    init(_ aBuffer: String) {
        self.buffer = aBuffer
    }
    
    func seek(_ aPointer: Pointer, until aPredicate: (Character) -> Bool) {
        while true {
            if startPtr >= buffer.count || endPtr >= buffer.count {
                eof = true
                break
            }
            
            // horribly disguisting
            switch aPointer {
            case .start:
                if aPredicate(buffer[buffer.index(buffer.startIndex, offsetBy: startPtr)]) {
                    return
                }
                
                startPtr += 1
            case .end:
                if aPredicate(buffer[buffer.index(buffer.startIndex, offsetBy: endPtr)]) {
                    return
                }
                
                endPtr += 1
            }
        }
    }
    
    func extract() -> String {
        return String(buffer[
            buffer.index(buffer.startIndex, offsetBy: startPtr)
            ..<
            buffer.index(buffer.startIndex, offsetBy: endPtr)
        ])
    }
    
    func jump(pointer aDestination: Pointer, to aSource: Pointer, plus anOffset: Int = 0) {
        if aDestination == .start && aSource == .end {
            startPtr = endPtr + anOffset
        } else if aDestination == .end && aSource == .start {
            endPtr = startPtr + anOffset
        }
    }
    
    func jump(pointer aPointer: Pointer, by anOffset: Int) {
        switch aPointer {
        case .start:
            startPtr += anOffset
        case .end:
            endPtr += anOffset
        }
    }
}

class Tokenizer: Scanner {
    private var tokens: [Token] = []
    private var index:  Int     = 0
    
    static let ws: String = " \r\n"
    static let punc: String = ";,(){}"
    
    private func ingestToken() {
        let data = extract()
        var type: TokenType = .identifier
        let keyword: Keyword? = Keyword(rawValue: data)
        
        if keyword != nil {
            type = .keyword
        } else if Self.punc.contains(data) {
            type = .punctuation(data)
        } else if data.reduce(true, { partial, char in
            partial && char.isNumber
        }) {
            type = .number
        }
        
        tokens.append(
            Token(data: extract(), type: type, keyword: keyword)
        )
    }
    
    func tokenize() {
        /*
         1. start pointer seek to non-whitespace
         2. end pointer: jump to start pointer
         3. check for EoF
         4. if not punc: end pointer: seek to white-space
         5. ingest token
         6. start pointer jump to end pointer
         */
        
        while true {
            // 1
            seek(.start) { char in
                !Self.ws.contains(char)
            }
            
            // 2
            jump(pointer: .end, to: .start, plus: 1)
            
            // 3
            guard !eof else { break }
            
            // 4
            if !Self.punc.contains(extract()) {
                seek(.end) { char in
                    Self.ws.contains(char) ||
                    Self.punc.contains(char)
                }
            }
            
            // 5
            ingestToken()
            
            // 6
            jump(pointer: .start, to: .end)
        }
    }
    
    func current() -> Token {
        return tokens[index]
    }
    
    func next(_ aCount: Int = 1) -> Bool {
        guard aCount >= 1 else { return false }
        guard index + aCount < tokens.count else { return false }
        
        index += aCount
        
        return true
    }
    
    func matches(pattern aPattern: [PatternFragment]) -> StatusResult<Bool> {
        let theOriginal = index
        
        defer {
            index = theOriginal
        }
        
        var theResult = StatusResult(value: true)
        
        for fragment in aPattern {
            switch fragment {
            case .type(let theType):
                if current().type != theType {
                    if let error = CommandError.fromType(theType) {
                        theResult.error = error
                    } else {
                        theResult.error = .notImplemented
                    }
                        
                    return theResult
                }
            case .keyword(let theKeyword):
                if current().keyword != theKeyword {
                    theResult.error = .unexpectedKeyword(expected: theKeyword)
                    
                    return theResult
                }
            }
            
            guard next() else { return theResult }
        }
        
        return theResult
    }
    
    func skipTo(type aType: TokenType) -> Token? {
        while current().type != aType {
            guard next() else { return nil }
        }
        
        return current()
    }
    
    func restart() {
        index = 0
    }
    
    func dump() {
        for token in tokens {
            print(token)
        }
    }
}
