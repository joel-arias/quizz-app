//
//  QuizManager.swift
//  EnhanceQuizStarter
//
//  Created by Joel Arias on 06/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit

struct QuizSettings {
    var questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
}

class QuizManager{
    
    var settings = QuizSettings()
    var questionProvider: QuestionProvider
    var selectedQuestion: Question
    
    init(questionProvider: QuestionProvider){
        self.questionProvider = questionProvider
        self.selectedQuestion = questionProvider.randomQuestion()
    }
    
    func getTrivia() -> Question {
        selectedQuestion = questionProvider.randomQuestion()
        return selectedQuestion
    }
    
    func displayScore(andHide button1: UIButton, and button2: UIButton, andShow playAgainButton: UIButton) -> String {
        // Hide the answer uttons
        button1.isHidden = true
        button2.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        return("Way to go!\nYou got \(settings.correctQuestions) out of \(settings.questionsPerRound) correct!")
    }
    
    func checkAnswer(from sender: UIButton, for trueButton: UIButton, and falseButton: UIButton, against correctAnswer: String) -> String{
        
        if (sender === trueButton && correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
            settings.correctQuestions += 1
            return "Correct!"
        } else {
            return "Sorry, wrong answer!"
        }
    }
}
