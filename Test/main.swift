//
//  main.swift
//  Test
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

func main() {
    let buf = "create circle (0, 0) (50, 50);"

    let theTokenizer = Tokenizer(buf)
    theTokenizer.tokenize()

    theTokenizer.dump()

    let model = TestModel()
    let proc = TestProcessor()

    defer {
        print(model.testAttr)
        
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
