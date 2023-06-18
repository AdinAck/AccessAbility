//
//  AccessAbilityApp.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import SwiftUI

@main
struct AccessAbilityApp: App {
    @StateObject var speech = SpeechRecognizer()
    @StateObject var gpt = GPTAdaptor(examples: [
        ("draw a circle",                                "create ellipse E1 (-50, -50) (100, 100);"           ),
        ("delete it",                                    "delete E1"                                          ),
        ("make a square to the right of the circle",     "create rectangle R1 (75, -50) (100, 100);"          ),
        ("move the rectangle to the left of the circle", "edit rectangle R1 (-175, -50) (100, 100);"          ),
        ("make the circle a little smaller",             "edit ellipse E1 (-25, -25) (50, 50);"               ),
        ("create another circle below the circle",       "create ellipse E2 (-25, 75) (50, 50);"              ),
        ("replace the first circle with a rectangle",    "delete E1; create rectangle R2 (-25, -25) (50, 50);"),
        ("delete the rectangle",                         "delete R2;"                                         ),
        ("clear the board",                              "delete *;"                                          )
    ])
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(speech)
                .environmentObject(gpt)
        }
    }
}
