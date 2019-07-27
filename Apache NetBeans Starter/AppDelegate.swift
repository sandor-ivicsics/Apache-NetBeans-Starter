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
    let JDKS_DIRECTORY = URL(fileURLWithPath: "/Library/Java/JavaVirtualMachines")

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.title = "Please, select Apache NetBeans home directory!"
        if (openPanel.runModal() != .OK) {
            return
        }
        guard let netbeansHome = openPanel.urls.first else {
            return
        }
        let netbeansShellScript = netbeansHome
            .appendingPathComponent("bin")
            .appendingPathComponent("netbeans")
            .path
        print("netbeansShellScript: \(netbeansShellScript)")
        let fileManager = FileManager.default;
        if (!fileManager.fileExists(atPath: netbeansShellScript)) {
            dialogCritical(messageText: "Invalid Apache NetBeans home directory!", informativeText: "Invalid Apache NetBeans home directory!")
            return
        }
        var netbeansJDKHome : String
        do {
            let jdks = try fileManager.contentsOfDirectory(at: JDKS_DIRECTORY, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            print("jdks: \(jdks)")
            netbeansJDKHome = jdks[3]
                .appendingPathComponent("Contents")
                .appendingPathComponent("Home")
                .path
            print("netbeansJDKHome: \(netbeansJDKHome)")
        } catch {
            print("Unexpected error: \(error).")
            return
        }
        let environment = ProcessInfo.processInfo.environment
        guard let home = environment["HOME"] else {
            return
        }
        guard let shell = environment["SHELL"] else {
            return
        }
        let process = Process()
        process.environment = [
            "HOME" : home,
            "netbeans_jdkhome" : netbeansJDKHome
        ]
        process.executableURL = URL(fileURLWithPath: shell)
        process.arguments = [netbeansShellScript]
        do {
            try process.run()
            NSApplication.shared.terminate(self)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func dialogCritical(messageText: String, informativeText: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

}

