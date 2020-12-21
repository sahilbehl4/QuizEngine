//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by TSL 150 on 2020-12-20.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation
import QuizEngine

class RouterSpy: Router {
    var routedResult: Result<String, String>? = nil
    var routedQuestions: [String] = []
    var answerCallback: (String) -> Void = { _ in}
    
    func routeToQuestion(question: String, answerCallback: @escaping ((String) -> Void)) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}
