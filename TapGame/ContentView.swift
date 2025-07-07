//
//  ContentView.swift
//  TapGame
//
//

import SwiftUI

struct ContentView: View {
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let possiblePics = ["Apple","Dog","Egg"]
    var randomTarget: Int {
        return Int.random(in: 0..<possiblePics.count)
    }
    
    enum Difficulty:Double {
        case easy = 1 , medium = 0.5 ,hard = 0.1
        
        var title: String{
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            }
        }
    }
    
    @State private var currentPicIndex = 0
    @State private var targetIndex = 1
    @State private var score = 0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var difficulty = Difficulty.easy
    @State private var isGameRunning = true
    
    
    
    var body: some View {
        VStack {
            HStack{
                if !isGameRunning{
                    Menu("Difficulty \(difficulty.title)") {
                        Button(Difficulty.easy.title) {
                            difficulty = .easy
                        }
                        Button(Difficulty.medium.title) {
                            difficulty = .medium
                        }
                        Button(Difficulty.hard.title) {
                            difficulty = .hard
                            
                        }
                    }}
                Spacer()
                Text("Score: \(score)")
            }
            .padding(.horizontal)
            
            Image(possiblePics[currentPicIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .onTapGesture {
                    timer.upstream.connect().cancel()
                    isGameRunning = false
                    if currentPicIndex == targetIndex {
                        score = score + 1
                        alertTitle = "Success"
                        alertMessage = "You got the correct answer"
                       
                    }else{
                        alertTitle = "Incorrect"
                        alertMessage = "You got the Incorrect answer"
                        
                    }
                    showAlert = true
                    
                }
            Text (possiblePics[targetIndex])
                .font(.headline)
                .padding(.top)
            if !isGameRunning{
                Button("Restart Game") {
                    targetIndex = randomTarget
                    timer = Timer.publish(every: difficulty.rawValue, on: .main, in: .common).autoconnect()
                    isGameRunning = true
                }
                .padding(.top)
            }
        }
        .onReceive(timer) { _ in
            changePic()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {

            }
        } message: {
            Text(alertMessage)
        }

    }
    
    func changePic(){
        if currentPicIndex == possiblePics.count - 1 {
        currentPicIndex = 0
        } else {
        currentPicIndex += 1
        }
        
    }
    
}

#Preview {
    ContentView()
}
