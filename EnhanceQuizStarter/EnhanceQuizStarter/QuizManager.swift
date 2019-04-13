//
//  QuizManager.swift
//  EnhanceQuizStarter
//
//  Created by Joel Arias on 06/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit

// This struct controls all the settings of the Quiz
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
    
    // Replace UIButton used to display the options with the labels related to the question displayed
    func replaceButtonLabels(of collectionOfButtons: [UIButton], from question: Question) {
        
        // Go through each of them to assign the correct title
        for option in collectionOfButtons{
            
            // Collecti index of option button within the collection of UIButtons
            let index: Int = collectionOfButtons.firstIndex(of: option)!
            
            // Check if current index exist in question object options.
            let isIndexValid = question.options.indices.contains(index)
            
            if isIndexValid{
                
                // Use index to select the appropriate option from the question object and set it as title
                option.setTitle(question.options[index], for: UIControl.State.normal)
            
            } else {
                
                // If there is no index then we can hide the option button
                option.isHidden = true
            
            }
        }
    }
    
    func displayScore(andHide allOptionButtons: [UIButton], andShow playAgainButton: UIButton) -> String {
        
        // Hide all option buttons
        for option in allOptionButtons{
            option.isHidden = true
        }
        
        // Display play again button
        playAgainButton.isHidden = false
        
        return("Way to go!\nYou got \(settings.correctQuestions) out of \(settings.questionsPerRound) correct!")
    }
    
    func checkAnswer(from sender: UIButton, against correctAnswer: String) -> (correct: Bool, label: String, color: UIColor){
        
        // Check if the UIButton matches the correct answer in the question object
        if (correctAnswer.isEqual(sender.titleLabel!.text!) ) {
            
            settings.correctQuestions += 1
            soundManager.loadPositiveSound()
            soundManager.playPositiveSound()
            return (correct: true, label: "Correct!", color: settings.correctColor )
        
        } else {
            
            soundManager.loadNegativeSound()
            soundManager.playNegativeSound()
            return (correct:false, label: "Sorry, wrong answer!", color: settings.wrongColor )
        }
    }
}
