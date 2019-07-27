//
//  AppDelegate.swift
//  Apache NetBeans Starter
//
//  Created by Ivicsics Sándor on 2019. 07. 27..
//  Copyright © 2019. ACC-Assist Kft. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        /*let environment = ProcessInfo.processInfo.environment
        guard let home = environment["HOME"] else {
            return
        }
        guard let shell = environment["SHELL"] else {
            return
        }
        let process = Process()
        process.environment = [
            "HOME" : home,
            "netbeans_jdkhome" : "/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home"
        ]
        process.executableURL = URL(fileURLWithPath: shell)
        process.arguments = ["/Users/ivicsicssandor/Development/netbeans-11.1/bin/netbeans"]
        do {
            try process.run()
            NSApplication.shared.terminate(self)
        } catch {
            print("Unexpected error: \(error).")
        }*/
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

