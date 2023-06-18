//
//  GPTAdaptor.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import Foundation
import OpenAISwift

class GPTAdaptor: ObservableObject {
    static private let apiKey: String = "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"
    private let gateway: OpenAISwift
    private var history: [ChatMessage] = []
    
    init(examples someExamples: [(String, String)]) {
        gateway = OpenAISwift(authToken: Self.apiKey)
        
        for (query, command) in someExamples {
            history.append(ChatMessage(role: .user, content: query))
            history.append(ChatMessage(role: .assistant, content: command))
        }
    }
    
    func ingest(query aQuery: String) async throws -> String {
        history.append(ChatMessage(role: .user, content: aQuery))
        
        let response = try await gateway.sendChat(
            with: history,
            model: .gpt4(.gpt4),
            temperature: 0.2
        )
        

        guard let choices = response.choices else { return "" }
        guard let best = choices.first else { return "" }
        
        history.append(best.message)
        
        let result = best.message.content
        
        return result
    }
}
