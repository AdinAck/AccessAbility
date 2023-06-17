//
//  ContentView.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/16/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var speech = SpeechRecognizer()
    
    var body: some View {
        VStack {
            Text("\(speech.transcript)")
                .animation(.spring(), value: speech.transcript)
            
            HStack {
                Button("Start") {
                    speech.resetTranscript()
                    speech.startTranscribing()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Stop") {
                    speech.stopTranscribing()
                }
                .tint(.red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
