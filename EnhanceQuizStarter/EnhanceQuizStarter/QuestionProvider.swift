//
//  QuestionProvider.swift
//  EnhanceQuizStarter
//
//  Created by Joel Arias on 06/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import GameKit

struct Question {
    var question: String
    var options: [String]
    var correctOption: String
    
    init(question: String, options: [String], correctOption: String) {
        self.question = question
        self.options = options
        self.correctOption = correctOption
    }
}


struct QuestionProvider{
    
    let question1 = Question(question: "Only female koalas can whistle", options: ["Verdadero", "Falso"], correctOption: "False")
    let question2 = Question(question: "Blue whales are technically whales", options: ["Vrai", "Faux"], correctOption: "True")
    let question3 = Question(question: "Camels are cannibalistic", options: ["True", "False"], correctOption: "False")
    let question4 = Question(question: "All ducks are birds", options: ["Veritat", "Fals"], correctOption: "True")
    var arrayOfQuestions: [Question] = []
    
    init() {
        self.arrayOfQuestions = [question1, question2, question3, question4]
    }
    
    func randomQuestion() -> Question {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: arrayOfQuestions.count)
        return arrayOfQuestions[randomNumber]
    }
}
