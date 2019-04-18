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
    let correctColor = UIColor(red: 0.000, green: 0.576, blue: 0.529, alpha: 1)
    let wrongColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
}

class QuizManager{
    
    var settings = QuizSettings()
    var questionProvider = QuestionProvider()
    var selectedQuestion: Question
    var soundManager = SoundManager(gameSound: 1, tapSound: 1, negativeSound: 1, positiveSound:1)
    
    // Store in "previousQuestionIDs" the question ID as soon as it is displayed. It helps avoid repetition of any question.
    var previousQuestionsIDs: [Int] = []
    
    init(){
        
        // Get first random question
        self.selectedQuestion = questionProvider.randomQuestion()
    }
    
    func getTrivia() -> Question {
        
        // Check if we already displayed the question by checking the stored ID in "previousQuestionsIDs"
        // Get a random question until we get one which ID doesn't match with any ID stored in "previousQuestionsIDs"
        while previousQuestionsIDs.contains(selectedQuestion.id){
            
            // Get random question
            selectedQuestion = questionProvider.randomQuestion()
        }
        
        // Store question ID
        previousQuestionsIDs.append(selectedQuestion.id)
        
        return selectedQuestion
        
    }
    
    func resetQuiz(){
        settings.questionsAsked = 0
        settings.correctQuestions = 0
        previousQuestionsIDs = []
    }
    
    func endGame() -> Bool{
        if settings.questionsAsked == settings.questionsPerRound {
            return true
        } else {
            return false
        }
    }
    
    func displayScore() -> String {
        
        return("Way to go!\nYou got \(settings.correctQuestions) out of \(settings.questionsPerRound) correct!")
    }
    
    func checkAnswer(from sender: String?, against correctAnswer: String, runOutofTime: Bool? = false) -> (correct: Bool, label: String){
        
        // Check if the UIButton matches the correct answer in the question object
        if (correctAnswer.isEqual(sender) ) {
            
            settings.correctQuestions += 1
            soundManager.loadPositiveSound()
            soundManager.playPositiveSound()
            return (correct: true, label: "Correct!")

        } else if runOutofTime == true{
            
            soundManager.loadNegativeSound()
            soundManager.playNegativeSound()
            return (correct: false, label: "Sorry, you've run out of time")
            
        } else {
            
            soundManager.loadNegativeSound()
            soundManager.playNegativeSound()
            return (correct:false, label: "Sorry, wrong answer!")
            
        }
        
    }
}
