//
//  TokenView.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import SwiftUI

struct TokenView: View {
    let tokens: [Token]
    
    private let colorMap: [TokenType: Color] = [
        .identifier: .purple,
        .keyword: .blue,
        .number: .orange
    ]
    
    private func getColor(from aType: TokenType) -> Color {
        if colorMap.keys.contains(aType) {
            return colorMap[aType]!
        }
        
        return .clear
    }
    
    var body: some View {
        HStack {
            ForEach(tokens, id: \.data) { token in
                Text(token.data)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(getColor(from: token.type))
                    )
            }
        }
    }
}

//struct TokenView_Previews: PreviewProvider {
//    static var previews: some View {
//        TokenView()
//    }
//}
