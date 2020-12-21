//
//  Result.swift
//  QuizEngine
//
//  Created by TSL 150 on 2020-12-20.
//  Copyright © 2020 sahil. All rights reserved.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public  let score: Int
}
