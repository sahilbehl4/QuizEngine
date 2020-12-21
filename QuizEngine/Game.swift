//
//  Game.swift
//  QuizEngine
//
//  Created by TSL 150 on 2020-12-20.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

public func startGame<Question, Answer, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) where R.Question == Question, R.Answer == Answer {
    
}
