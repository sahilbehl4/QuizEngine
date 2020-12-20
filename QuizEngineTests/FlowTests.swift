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
    
    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(router.routedResult!.isEmpty)
    }
    
    func test_start_withOneQuestion_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerOneQuestion_withTwoQuestions_doesNotRoutesToResult() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()

        router.answerCallback("A1")

        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerAll_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()

        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResult!, ["Q1":"A1", "Q2":"A2"])
    }

    // MARK: - Helpers
    
    func makeSUT(questions: [String]) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router)
    }

    class RouterSpy: Router {
        var routedResult: [String: String]? = nil
        var routedQuestions: [String] = []
        var answerCallback: (String) -> Void = { _ in}
        
        func routeToQuestion(question: String, answerCallback: @escaping ((String) -> Void)) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: [String : String]) {
            routedResult = result
        }
    }
}
