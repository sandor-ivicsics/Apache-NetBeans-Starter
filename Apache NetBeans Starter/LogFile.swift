//
//  LogFile.swift
//  Apache NetBeans Starter
//
//  Created by Ivicsics Sándor on 2019. 08. 10..
//  Copyright © 2019. ACC-Assist Kft. All rights reserved.
//

import Foundation

class LogFile: TextOutputStream {
    let logFileHandle: FileHandle?
    
    init() {
        let fileManager = FileManager.default
        let logDirectory = fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".Apache-NetBeans-Starter")
        var isDirectoy = ObjCBool(false)
        if !fileManager.fileExists(atPath: logDirectory.path, isDirectory: &isDirectoy)
            || !isDirectoy.boolValue {
            do {
                try fileManager.createDirectory(at: logDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Unexpected error: \(error).")
                logFileHandle = nil
                return
            }
        }
        let logFile = logDirectory.appendingPathComponent("log.txt")
        isDirectoy = ObjCBool(false)
        if !fileManager.fileExists(atPath: logFile.path, isDirectory: &isDirectoy)
            || isDirectoy.boolValue {
            if !fileManager.createFile(atPath: logFile.path, contents: nil, attributes: nil) {
                logFileHandle = nil
                return
            }
        }
        logFileHandle = FileHandle(forWritingAtPath: logFile.path)
        logFileHandle?.seekToEndOfFile()
    }
    
    deinit {
        logFileHandle?.closeFile()
    }
    
    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        logFileHandle?.write(data)
    }
}
