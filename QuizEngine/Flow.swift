//
//  Flow.swift
//  QuizEngine
//
//  Created by Sahil Behl on 2020-11-26.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeToQuestion(question: String, answerCallback: @escaping ((String) -> Void))
}

class Flow {
    private let router: Router
    private let questions: [String]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeToQuestion(question: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return  { [weak self] _ in
            guard let strongSelf = self else { return }
            if let currentQuestionIndex = strongSelf.questions.firstIndex(of: question), currentQuestionIndex + 1 < strongSelf.questions.count {
                let nextQuestion = strongSelf.questions[currentQuestionIndex + 1]
                strongSelf.router.routeToQuestion(question: nextQuestion, answerCallback: strongSelf.routeNext(from: nextQuestion))
            }
        }
    }
}
