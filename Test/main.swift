//
//  main.swift
//  Test
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

func main() {
    let buf = "\ncreate ellipse E1 (0, 0) (50, 50);"

    let theTokenizer = Tokenizer(buf)
    guard theTokenizer.tokenize() > 0 else { return }

    theTokenizer.dump()

    let model = Canvas()
    let proc = CanvasProcessor()

    defer {
        print(model.items)
        
        print("Done!")
    }
    
    let theResult = proc.recognizes(theTokenizer)

    if let error = theResult.error {
        print(error)
        return
    }
    
    guard theResult.value else { return }
    
    proc.run(model)
}

main()
