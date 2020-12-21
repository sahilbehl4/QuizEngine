//
//  GameTest.swift
//  QuizEngineTests
//
//  Created by TSL 150 on 2020-12-20.
//  Copyright © 2020 sahil. All rights reserved.
//

import XCTest
import QuizEngine

class GameTests: XCTestCase {
    func test_startGame_answerOneOutOfTwoCorrectly_scores1() {
        let router = RouterSpy()
        startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
        
        router.answerCallback("A1")
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
}
