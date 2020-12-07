//
//  Log.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

struct Log {
    
    enum Level: String, CaseIterable {
        case info = "INFO"
        case debug = "DEBUG"
        case error = "ERROR"
        case warning = "WARNING"
        case trace = "TRACE"
    }
    
    #if DEBUG
        static var levels = Level.allCases
    #else
        static var levels: [Level] = [.info, .error]
    #endif
    
    static func info(_ message: String) {
        log(message, level: .info)
    }
    
    static func debug(_ message: String) {
        log(message, level: .debug)
    }
    
    static func error(_ message: String) {
        log(message, level: .error)
    }
    
    static func assertionFailure(_ message: String) {
        Swift.assertionFailure(message)
        error(message)
    }
    
    static func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    static func trace(_ message: String) {
        log(message, level: .trace)
    }
    
    static func log(_ message: String, level: Level) {
        guard levels.contains(level) else {
            return
        }
        print("[\(level.rawValue)]: \(message)")
    }
}
