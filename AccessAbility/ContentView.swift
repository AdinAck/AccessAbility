//
//  ContentView.swift
//  AccessAbility
//
//  Created by Adin Ackerman on 6/17/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var speech: SpeechRecognizer
    @EnvironmentObject var gpt: GPTAdaptor
    
    @StateObject var canvas = Canvas()
    
    @State var responseRaw: String = ""
    @State var responseTokens: [Token] = []
    @State var thinking: Bool = false
    
    @State private var counter: Int = 0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    func process(response aResponse: String) -> StatusResult<Bool> {
        let theTokenizer = Tokenizer(aResponse)
        guard theTokenizer.tokenize() > 0 else { return StatusResult(value: false)}
        
        responseTokens.append(contentsOf: theTokenizer.tokens)
        
        let proc = CanvasProcessor()
        
        var theResult = proc.recognizes(theTokenizer)
        
        guard theResult.value else { return theResult }
        
        if theResult.error != nil {
            return theResult
        }
        
        theResult = proc.run(canvas)
        
        return theResult
    }
    
    var body: some View {
        ZStack {
            CanvasView()
                .environmentObject(canvas)
            
            VStack {
                HStack {
                    Text(speech.transcript)
                        .bold()
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    if thinking {
                        ProgressView()
                    } else if speech.isRecording { // kinda hacky but whatever
                        TokenView(tokens: responseTokens)
                    }
                    
                    Button(speech.isRecording ? "Transcribing" : thinking ? "..." : "Ready") {
                        if speech.isRecording {
                            speech.stopTranscribing()
                        } else {
                            speech.resetTranscript()
                            speech.startTranscribing()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(speech.isRecording ? .red : thinking ? .orange : .blue)
                    .padding()
                }
                .background(.background)
                .animation(.default, value: thinking)
                .animation(.default, value: speech.transcript)
                .animation(.default, value: speech.isRecording)
                
                Spacer()
            }
        }
            .onChange(of: speech.transcript) { newValue in
                counter = 0
            }
            .onReceive(timer) { _ in
                Task {
                    if counter >= 10 {
                        if speech.transcript != "" {
                            speech.stopTranscribing()
                            thinking = true
                            do {
                                responseRaw = try await gpt.ingest(query: speech.transcript.lowercased())
                                responseTokens = []
                                
                                for segment in responseRaw.components(separatedBy: ";") {
                                    let theResult = process(response: segment)
                                    
                                    if let error = theResult.error {
                                        print("[ERR] Proc failed with error (\(error).")
                                    }
                                }
                                
                            } catch {
                                responseRaw = "Error"
                            }
                            
                            thinking = false
                            speech.resetTranscript()
                            speech.startTranscribing()
                        }
                        counter = 0
                    } else {
                        counter += 1
                    }
                }
            }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
