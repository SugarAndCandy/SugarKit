//
//  RecordError.swift
//  Record
//
//  Created by Maksim Kolesnik on 20.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public struct RecordError: Error {
    let file: String
    let function: String
    let message: String
}
