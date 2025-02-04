//
//  LogUtility.swift
//  EkyWeather
//
//  Created by Eky on 01/02/25.
//

import SwiftyBeaver


class LogUtility {
    
    static let shared = LogUtility()
    
    private let _log = SwiftyBeaver.self
    
    var log: SwiftyBeaver.Type {
        get {
            return _log
        }
    }
    
    init() {
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file

        // use custom format and set console output to short time, log level & message
        console.format = "$DHH:mm:ss$d $L $M"
        // or use this for JSON output: console.format = "$J"

        // In Xcode 15, specifying the logging method as .logger to display color, subsystem, and category information in the console.(Relies on the OSLog API)
        console.logPrintWay = .logger(subsystem: "Main", category: "UI")
        // If you prefer not to use the OSLog API, you can use print instead.
        // console.logPrintWay = .print

        // add the destinations to SwiftyBeaver
        _log.addDestination(console)
        _log.addDestination(file)
    }
}
