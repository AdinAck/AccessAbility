//
//  GPTAdaptor.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation
import OpenAISwift
import DotEnv

class GPTAdaptor: ObservableObject {
    private let gateway: OpenAISwift
    private var history: [ChatMessage] = []
    
    private var convCache: (ChatMessage, ChatMessage)? = nil
    
    init(prologue aPrologue: String, examples someExamples: [(String, String)]) {
        let path = Bundle.main.path(forResource: "secret", ofType: "env")
        try! DotEnv.load(path: path!)
        
        gateway = OpenAISwift(authToken: ProcessInfo.processInfo.environment["API_KEY"]!)
        
        history.append(ChatMessage(role: .system, content: aPrologue))
        
        for (query, command) in someExamples {
            history.append(ChatMessage(role: .user, content: query))
            history.append(ChatMessage(role: .assistant, content: command))
        }
    }
    
    func ingest(query aQuery: String) async throws -> String {
        let q = ChatMessage(role: .user, content: aQuery)
        
        let response = try await gateway.sendChat(
            with: history + [q],
            model: .gpt4(.gpt4),
            temperature: 0.2
        )
        

        guard let choices = response.choices else { return "" }
        guard let best = choices.first else { return "" }
        
        let result = best.message.content
        
        convCache = (q, best.message)
        
        return result
    }
    
    func recordValidTransaction() {
        if let convCache {
            history.append(convCache.0)
            history.append(convCache.1)
        }
    }
}
