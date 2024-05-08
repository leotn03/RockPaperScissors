//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Leo Torres Neyra on 4/10/23.
//

import SwiftUI

struct WithPickerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(.segmented)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 15)
        
    }
}

struct WithTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .padding(15)
    }
}

extension View {
    func changePicker () -> some View{
        modifier(WithPickerStyle())
    }

    func changeTextStyle  () -> some View {
        modifier(WithTextStyle())
    }
}

struct ContentView: View {
    let options = ["🪨", "📄", "✂️"]
    let gameOptions = ["Win","Lose"]
    
    @State private var appChoice = "👀"
    @State private var playerChoice = "📄"
    @State private var toWin = "Win"
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var round = 0
    @State private var showAlert = false
    @State private var restartGame = false
    
    var body: some View {
        NavigationView{
            ZStack {
                //Estilo por gradiente radial
                /*RadialGradient(stops: [
                 .init(color: Color(red: 0.1, green: 0.9, blue: 0.75), location: 0.3),
                 .init(color: Color(red: 0.1, green: 0.1, blue: 1.96), location: 0.9),
                 .init(color: Color(red: 1.7, green: 0.8, blue: 0.1), location: 0.3)
                 ], center: .topLeading, startRadius: 200, endRadius: 700)
                 .ignoresSafeArea()*/
                
                //Estilo con gradiente linear
                /*LinearGradient(colors: [Color.blue, Color.green, Color.yellow], startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea()*/
                
                // Estilo con grandiente angular
                AngularGradient(colors: [Color.blue, Color.green, Color.yellow], center: .center)
                    .ignoresSafeArea()
                
                VStack  {
                    VStack(alignment: .leading){
                        Spacer()
                        Text("App Choice 🤖")
                            .changeTextStyle()
                        
                        HStack{
                            Spacer()
                            Text(appChoice)
                                .font(.system(size: 40))
                                .frame(width: 100,height: 70)
                                .background(.thickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Text("Player Choice 🙍🏻‍♂️")
                            .changeTextStyle()
                        
                        Picker("Player Choice", selection: $playerChoice) {
                            ForEach(options, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .changePicker()
                        
                        Text("Game Mode 🕹️")
                            .changeTextStyle()
                        
                        Picker("Game Mode", selection: $toWin) {
                            ForEach(gameOptions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .changePicker()
                        
                        Spacer()
                        Divider()
                        
                        Text("Score:     \(score)")
                            .changeTextStyle()
                        Text("Round:    \(round)")
                            .changeTextStyle()
                        
                        Spacer()
                    }
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: 370, height: 500)
                    .padding(.top,30)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Section{
                            Button("Play"){
                                if toWin == "Win"{
                                    playGame(shouldWin: true)
                                }else{
                                    playGame(shouldWin: false)
                                }
                            }
                            .frame(width: 150, height: 50)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .changeTextStyle()
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .background(.ultraThinMaterial)
                
            }
            .navigationTitle("Game 🪨 📄 ✂️")
        
            .alert(scoreTitle, isPresented: $showAlert) {
                Button("Continue"){ }
            }message: {
                Text("Your score is: \(score)")
            }
            .alert(scoreTitle, isPresented: $restartGame){
                Button("Continue", action: reset)
            }message:{
                Text("You score is: \(score)")
            }
        }
    }
    
    func playGame (shouldWin: Bool) {
        round += 1
        appChoice = options.shuffled().randomElement()!
        
        if appChoice != playerChoice {
            switch playerChoice {
            case "✂️":
                if appChoice == "📄" && shouldWin{
                    score += 1
                    scoreTitle = "You Win!".uppercased()
                }else if appChoice == "🪨" && !shouldWin{
                    score += 1
                    scoreTitle = "You Win!".uppercased()
                }else{
                    score -= 1
                    score = score >= 0 ? score : 0
                    scoreTitle = "You Lose!".uppercased()
                }
            case "📄":
                if appChoice == "🪨" && shouldWin{
                    score += 1
                    scoreTitle = "You Win!".uppercased()
                }else if appChoice == "✂️" && !shouldWin {
                    score += 1
                    scoreTitle = "You Win!".uppercased()
                } else {
                    score -= 1
                    score = score >= 0 ? score : 0
                    scoreTitle = "You Lose!".uppercased()
                }
            case "🪨":
                if appChoice == "✂️" && shouldWin{
                    score += 1
                }else if appChoice == "📄" && !shouldWin{
                    score += 1
                }else{
                    score -= 1
                    score = score >= 0 ? score : 0
                }
            default:
                return
            }
        }else{
            scoreTitle = "It's a draw!".uppercased()
        }
        
        if round >= 10 {
            restartGame = true
            scoreTitle = "End of the Game!".uppercased()
            return
        }
        
        showAlert = true
    }
    
    func reset () {
        appChoice = "👀"
        score = 0
        round = 0
        showAlert = false
    }
}

#Preview {
    ContentView()
}
