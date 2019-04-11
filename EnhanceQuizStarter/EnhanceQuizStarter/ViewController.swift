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
    let soundManager = SoundManager(gameSound: 10)
    let quizManager = QuizManager(questionProvider: QuestionProvider())
    var trivia = Question(question: "", options: ["", ""], correctOption: "")
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet var optionButtons:[UIButton]!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundManager.loadGameStartSound()
        soundManager.playGameStartSound()
        trivia = quizManager.getTrivia()
        questionField.text = trivia.question
        optionButtons[0].setTitle(trivia.options[0], for: UIControl.State.normal)
        optionButtons[1].setTitle(trivia.options[1], for: UIControl.State.normal)
        playAgainButton.isHidden = true
    }
    
    // MARK: - Helpers
    
    func nextRound() {
        if quizManager.settings.questionsAsked == quizManager.settings.questionsPerRound {
            // Game is over
            questionField.text = quizManager.displayScore(andHide: optionButtons[0], and: optionButtons[1], andShow: playAgainButton)
        } else {
            // Continue game
            trivia = quizManager.getTrivia()
            questionField.text = trivia.question
            optionButtons[0].setTitle(trivia.options[0], for: UIControl.State.normal)
            optionButtons[1].setTitle(trivia.options[1], for: UIControl.State.normal)
        }
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        quizManager.settings.questionsAsked += 1
        
        let result = quizManager.checkAnswer(from: sender, for: optionButtons[0], and: optionButtons[1], against: trivia.correctOption)
        questionField.text = result
        
        loadNextRound(delay: 1)
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Show the answer buttons
        optionButtons[0].isHidden = false
        optionButtons[1].isHidden = false
        sender.isHidden = true
        
        quizManager.settings.questionsAsked = 0
        quizManager.settings.correctQuestions = 0
        nextRound()
    }
    

}

