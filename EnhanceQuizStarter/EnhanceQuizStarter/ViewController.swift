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
    let correctColor = UIColor(red: 0.000, green: 0.576, blue: 0.529, alpha: 1)
    let wrongColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
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
        setOptionButtonReady(of: optionButtons, from: trivia)
        
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
            changeButtonsState(of: optionButtons, and: resultsField, for: trivia, using: result, checkSender: nil)
            
            // Show "Next Question" button
            playAgainButton.isHidden = false
            
        } else {
            
            // Decrease 1 second
            seconds -= 1
            
            // Display seconds left
            resultsField.text = "\(seconds)"
        }
        
    }
    
    // Feed UIButtons labels with the options inside question object. Remove UIButtons that are not necessary
    func setOptionButtonReady(of collectionOfButtons: [UIButton], from question: Question) {
        
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
                
                // If there is no valid index then we can hide the UIButton
                option.isHidden = true
                
            }
        }
    }
    
    func changeButtonsState(of buttons: [UIButton], and field: UILabel, for question: Question, using result: (correct: Bool, label: String), checkSender sender: UIButton?){
        
        // Change opacity of options
        for button in buttons{
            button.layer.opacity = 0.25
            button.isEnabled = false
        }
        
        // Apply returned result to result field
        field.text = result.label
        
        // Apply returned color to text and button
        let color: UIColor
        
        if result.correct {
            color = correctColor
        } else {
            color = wrongColor
        }
        
        field.textColor = color
        
        // If sender then change its background color
        sender?.backgroundColor = color
        
        // Look for the correct option for the current question object
        for option in buttons{
            
            if question.correctOption.isEqual(option.titleLabel!.text){
                
                // Highlight correct option
                option.backgroundColor = UIColor(red: 0.000, green: 0.576, blue: 0.529, alpha: 1)
                option.layer.opacity = 1
                
            }
        }
    }
    
    func nextRound() {
        if quizManager.endGame() {
            
            // Game is over. We display the score and hide the option buttons
            questionField.text = quizManager.displayScore()
            
            // Hide all option buttons
            for option in optionButtons{
                option.isHidden = true
            }
            
            // Display play again button
            playAgainButton.isHidden = false
            
            // Reset Quiz settings
            quizManager.resetQuiz()
            
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
            setOptionButtonReady(of: optionButtons, from: trivia)
            
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
        let result = quizManager.checkAnswer(from: sender.titleLabel!.text!, against: trivia.correctOption)
        
        // Change all buttons state styles according to the result
        changeButtonsState(of: optionButtons, and: resultsField, for: trivia, using: result, checkSender: sender)
    
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

