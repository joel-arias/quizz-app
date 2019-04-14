//
//  QuestionProvider.swift
//  EnhanceQuizStarter
//
//  Created by Joel Arias on 06/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import GameKit

struct Question {
    var id: Int
    var question: String
    var options: [String]
    var correctOption: String
    
    init(id: Int, question: String, options: [String], correctOption: String) {
        self.id = id
        self.question = question
        self.options = options
        self.correctOption = correctOption
    }
}


struct QuestionProvider{
    
    var arrayOfQuestions: [Question] =
        [
            Question(id:1, question: "Who designed the Universe typeface?", options: ["Adrian Frutiger", "Erik Spiekermann", "Max Bill", "Matthew Carter"], correctOption: "Adrian Frutiger"),
            Question(id:2, question: "Who wrote the book RAYUELA?", options: ["Julio Cortázar", "Victor Hugo", "William Shakespear"], correctOption: "Julio Cortázar"),
            Question(id:3, question: "What is the capital of Spain?", options: ["Madrid", "Valencia", "Bilbao", "Sevilla"], correctOption: "Madrid"),
            Question(id:4, question: "Which of the following paintings is NOT from Pablo Picasso?", options: ["Les Demoiselles d'Avignon", "The Weeping Woman", "Harlequin with Guitar", "The Old Guitarist"], correctOption: "Harlequin with Guitar")
    ]
    
    func randomQuestion() -> Question {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: arrayOfQuestions.count)
        return arrayOfQuestions[randomNumber]
    }
}
