//
//  Flow.swift
//  QuizEngine
//
//  Created by Sahil Behl on 2020-11-26.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    func routeToQuestion(question: Question, answerCallback: @escaping ((Answer) -> Void))
    func routeTo(result: [Question: Answer])
}

class Flow<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let router: R
    private let questions: [Question]
    private var result: [Question: Answer] = [:]
    
    init(questions: [Question], router: R) {
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
    
    private func nextCallback(from question: Question) -> ((Answer) -> Void) {
        return  { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
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
