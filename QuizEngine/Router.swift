//
//  Router.swift
//  QuizEngine
//
//  Created by TSL 150 on 2020-12-20.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    func routeToQuestion(question: Question, answerCallback: @escaping ((Answer) -> Void))
    func routeTo(result: Result<Question, Answer>)
}
