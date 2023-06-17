//
//  main.swift
//  Test
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation

let buf = "create circle (0, 0) (50, 50);"

let theTokenizer = Tokenizer(buf)
theTokenizer.tokenize()

theTokenizer.dump()

print("Done!")
