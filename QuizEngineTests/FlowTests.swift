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
    let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(router.routedQuestions.isEmpty, true)
    }
    
    func test_start_withOneQuestions_doesRouteToQuestion() {
        makeSUT(questions: ["01"]).start()
        
        XCTAssertEqual(router.routedQuestions.count, 1)
    }
    
    func test_start_withOneQuestions_doesRouteToCorrectQuestion() {
        makeSUT(questions: ["01"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["01"])
    }
    
    
    func test_start_withTwoQuestions_doesRouteToCorrectQuestion_2() {
        makeSUT(questions: ["Q1","Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_doesRouteToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesRouteToSecondQuestion() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        
        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_doesRouteToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1","Q2", "Q3"])
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToNextQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    // MARK: - Helpers
    
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: Router.AnswerCallback = { _ in}
        
        func routeToQuestion(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
}
