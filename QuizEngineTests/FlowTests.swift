//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Sahil Behl on 2020-11-26.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation
import XCTest

@testable import QuizEngine

class FlowTest: XCTestCase {
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions.isEmpty, true)
    }
    
    func test_start_withOneQuestions_doesRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["01"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions.count, 1)
    }
    
    func test_start_withOneQuestions_doesRouteToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["01"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["01"])
    }
    
    
    func test_start_withTwoQuestions_doesRouteToCorrectQuestion_2() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_doesRouteToFirstQuestionTwice() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"], router: router)

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswer_withTwoQuestions_doesRouteToSecondQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1","Q2"], router: router)
        sut.start()
        
        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = { _ in}
        
        func routeToQuestion(question: String, answerCallback: @escaping ((String) -> Void)) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
}
