//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Joel Arias on 06/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    let soundManager = SoundManager(gameSound: 1, tapSound: 1, negativeSound: 1, positiveSound: 1)
    let quizManager = QuizManager()
    var trivia = Question(id:0, question: "", options: ["", ""], correctOption: "")
    var seconds = 15
    var timer = Timer()
    
    // MARK: - Outlets
    
    // Display questions here
    @IBOutlet weak var questionField: UILabel!
    
    @IBOutlet weak var resultsField: UILabel!
    
    // Collection storing all available option buttons
    @IBOutlet var optionButtons:[UIButton]!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load and initialize sound
        soundManager.loadGameStartSound()
        soundManager.loadTapSound()
        soundManager.playGameStartSound()
        
        // Init Timer
        runTimer()
        
        // Reformat Button Styles
        for button in optionButtons{
            button.layer.cornerRadius = 8
        }
        
        playAgainButton.layer.cornerRadius = 8
        
        // Get first question
        trivia = quizManager.getTrivia()
        questionField.text = trivia.question
        
        // Place options from trivia instance of question object
        quizManager.replaceButtonLabels(of: optionButtons, from: trivia)
        
        resultsField.isHidden = false
        playAgainButton.isHidden = true
    }
    
    // MARK: - Helpers
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        if seconds <= 1 {
            
            // Stop timer
            timer.invalidate()
            
            // Increment the questions asked counter
            quizManager.settings.questionsAsked += 1
            
            
            // Check answer to know which is the correct answer
            let result = quizManager.checkAnswer(from: nil, against: trivia.correctOption, runOutofTime: true)
            
            // Show correct answer and hide the rest of the options. Display message indicating that you've run out of time.
            quizManager.changeButtonsState(of: optionButtons, and: resultsField, for: trivia, using: result, checkSender: nil)
            
            // Show "Next Question" button
            playAgainButton.isHidden = false
            
        } else {
            
            // Decrease 1 second
            seconds -= 1
            
            // Display seconds left
            resultsField.text = "\(seconds)"
        }
        
    }
    
    func nextRound() {
        if quizManager.settings.questionsAsked == quizManager.settings.questionsPerRound {
            
            // Game is over. We display the score and hide the option buttons
            questionField.text = quizManager.displayScore(andHide: optionButtons, andShow: playAgainButton)
            
            // Reset Quiz settings
            quizManager.settings.questionsAsked = 0
            quizManager.settings.correctQuestions = 0
            quizManager.previousQuestionsIDs = []
            
            // Change Button label
            playAgainButton.setTitle("Play Again", for: UIControl.State.normal)
            
            resultsField.isHidden = true
            
        } else {
            
            // Check last question is being displayed. Show "View Results" instead of "Next Question" if so.
            if quizManager.settings.questionsAsked == 3 {
                
                playAgainButton.setTitle("View Results", for: UIControl.State.normal)
                
            } else {
                
                playAgainButton.setTitle("Next Question", for: UIControl.State.normal)
            }
            
            // Reset timer
            seconds = 15
            resultsField.textColor = UIColor.white
            resultsField.text = "\(seconds)"
            runTimer()
            
            // Get new question object and replace option buttons label with the new ones
            trivia = quizManager.getTrivia()
            questionField.text = trivia.question
            quizManager.replaceButtonLabels(of: optionButtons, from: trivia)
            
            resultsField.isHidden = false
            playAgainButton.isHidden = true
            
            // Reset option buttons original style
            for button in optionButtons{
                button.isEnabled = true
                button.backgroundColor = UIColor(red: 0.047, green: 0.475, blue: 0.588, alpha: 1)
                button.layer.opacity = 1.0
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        // Increment the questions asked counter
        quizManager.settings.questionsAsked += 1
        
        // Stop timer
        timer.invalidate()
        
        playAgainButton.isHidden = false
        
        // Change opacity of options
        for button in optionButtons{
            button.layer.opacity = 0.25
            button.isEnabled = false
        }
        
        // Check answer reading the tapped button against the correct option stored in the question object called "trivia"
        let result = quizManager.checkAnswer(from: sender, against: trivia.correctOption)
        
        // Change all buttons state styles according to the result
        quizManager.changeButtonsState(of: optionButtons, and: resultsField, for: trivia, using: result, checkSender: sender)
    
        // Reset opacity of selected option.
        sender.layer.opacity = 1
        
        resultsField.isHidden = false
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        
        // Next question sound
        soundManager.playTapSound()
        
        // Hide all option buttons
        for option in optionButtons{
            option.isHidden = false
        }
        
        // Hide button used to trigger playAgain()
        nextRound()
    }
    

}

