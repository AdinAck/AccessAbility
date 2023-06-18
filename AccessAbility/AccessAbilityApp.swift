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
    @StateObject var gpt = GPTAdaptor(
        prologue: "you are controlling a drawing app via a vocal interface. the user will ask you to draw, edit, or delete items on a canvas. you will output commands to pass to the app in the form of a custom scripting language. the scripting language is straight forward. you can create edit and delete items. the commands usually go by the form {keyword} {type} {identifier} {bounding box}. the default color is white, and the default stroke weight is 8.",
        examples: [
            ("draw a blue circle",                              "create ellipse E1 (-50, -50) (100, 100); color E1 blue;"      ),
            ("delete it",                                       "delete E1"                                                    ),
            ("make a square to the right of the circle",        "create rectangle R1 (75, -50) (100, 100);"                    ),
            ("move the square to the left of the circle",       "edit rectangle R1 (-175, -50) (100, 100);"                    ),
            ("make it red",                                     "color R1 red;"                                                ),
            ("make the circle a little smaller",                "edit ellipse E1 (-25, -25) (50, 50);"                         ),
            ("create another circle below the circle",          "create ellipse E2 (-25, 75) (50, 50);"                        ),
            ("replace the first circle with a rectangle",       "delete E1; create rectangle R2 (-25, -25) (50, 50);"          ),
            ("delete the rectangle",                            "delete R2;"                                                   ),
            ("clear the board",                                 "delete E2; delete R1; delete R2;"                             ),
            ("draw a circle",                                   "create ellipse E1 (-50, -50) (100, 100);"                     ),
            ("move it up",                                      "edit ellipse E1 (-50, -100) (100, 100);"                      ),
            ("left a bit",                                      "edit ellipse E1 (-100, -100) (100, 100);"                     ),
            ("draw another circle to the right",                "create ellipse E2 (0, -100) (100, 100);"                      ),
            ("draw a rectangle around the circles",             "create rectangle R1 (-125, -125) (250, 125);"                 ),
            ("show me the circle on the right",                 "view E2;"                                                     ),
            ("make the right circle bigger",                    "edit ellipse E2 (-150, -150) (200, 200);"                     ),
            ("delete everything",                               "delete E1; delete E2; delete R1;"                             ),
            ("draw a rectangle",                                "create rectangle R1 (-100, -50) (200, 100);"                  ),
            ("move it left a lot",                              "edit rectangle R1 (-400, -50) (200, 100);"                    ),
            ("down a bit",                                      "edit rectangle R1 (-400, 0) (200, 200);"                      ),
            ("center the rectangle",                            "edit rectangle R1 (-100, -50) (200, 100);"                    ),
            ("make it half as wide",                            "edit rectangle R1 (-50, -50) (100, 100);"                     ),
            ("delete it",                                       "delete R1;"                                                   ),
            ("center the screen",                               "view center;"                                                 ),
            ("draw a thick diagonal line",                      "create line L1 (-100, -100) (200, 200); stroke L1 16;"        ),
            ("diagonal the other way",                          "edit line L1 (-100, 100) (200, -200);"                        ),
            ("delete it",                                       "delete L1;"                                                   ),
            ("make a vertical line",                            "create line L1 (0, -100) (0, 200);"                           ),
            ("and another line across it",                      "create line L2 (-100, 0) (200, 0);"                           ),
            ("draw a square around them",                       "create rectangle R1 (-100, -100) (200, 200);"                 ),
            ("replace the square with a circle",                "delete R1; create ellipse E1 (-100, -100) (200, 200);"        ),
            ("make the circle thinner",                         "stroke E1 4;"                                                 ),
            ("draw a line diagonally through the circle",       "create line L3 (-100, -100) (200, 200);"                      ),
            ("make the line start at the center of the circle", "edit line L3 (0, 0) (100, 100);"                              ),
            ("center the line",                                 "edit line L3 (-50, -50) (100, 100);"                          ),
            ("delete everything",                               "delete L1; delete L2; delete E1;"                             )
        ]
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(speech)
                .environmentObject(gpt)
        }
    }
}
