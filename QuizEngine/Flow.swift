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
    func routeTo(result: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    private var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeToQuestion(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }
    
    private func nextCallback(from question: String) -> Router.AnswerCallback {
        return  { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            if currentQuestionIndex + 1 < questions.count {
                let nextQuestion = questions[currentQuestionIndex + 1]
                router.routeToQuestion(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
            
        }
    }
}
