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
        let userDefaults = UserDefaults.standard
        var netbeansJDKHome = userDefaults.string(forKey: "netbeans_jdk_home")
        if netbeansJDKHome == nil {
            netbeansJDKHome = getInstalledJDKHome(installedJDK: selectInstalledJDK())
            if netbeansJDKHome == nil {
                netbeansJDKHome = selectJDKHome()?.path
                if netbeansJDKHome == nil {
                    return
                }
            }
            userDefaults.set(netbeansJDKHome, forKey: "netbeans_jdk_home")
        }
        print("netbeansJDKHome: \(netbeansJDKHome ?? "")")
        var netbeansShellScript = getNetBeansShellScript(netbeansHome: userDefaults.url(forKey: "netbeans_home"))
        if netbeansShellScript == nil {
            let netbeansHome = selectNetBeansHome()
            netbeansShellScript = getNetBeansShellScript(netbeansHome: netbeansHome)
            if netbeansShellScript == nil {
                return
            }
            userDefaults.set(netbeansHome, forKey: "netbeans_home")
        }
        print("netbeansShellScript: \(netbeansShellScript ?? "")")
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
            "netbeans_jdkhome" : netbeansJDKHome!
        ]
        process.executableURL = URL(fileURLWithPath: shell)
        process.arguments = [netbeansShellScript!]
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
    
    func getInstalledJDKHome(installedJDK: URL?) -> String? {
        guard let installedJDK = installedJDK else {
            return nil
        }
        let installedJDKHome = installedJDK
            .appendingPathComponent("Contents")
            .appendingPathComponent("Home")
            .path
        print("installed JDK home: \(installedJDKHome)")
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: installedJDKHome)) {
            return installedJDKHome
        }
        return nil
    }
    
    func selectInstalledJDK() -> URL? {
        let fileManager = FileManager.default
        do {
            let installedJDKs = try fileManager.contentsOfDirectory(
                at: URL(fileURLWithPath: "/Library/Java/JavaVirtualMachines")
                , includingPropertiesForKeys: nil
                , options: .skipsHiddenFiles
            )
            print("installed JDKs: \(installedJDKs)")
            // TODO
            return installedJDKs[3]
        } catch {
            print("Unexpected error: \(error).")
            return nil
        }
    }
    
    func selectDirectory(title: String) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.title = title
        if (openPanel.runModal() != .OK) {
            return nil
        }
        return openPanel.urls.first
    }
    
    func selectJDKHome() -> URL? {
        return selectDirectory(title: "Please, select JDK home directory!")
    }
    
    func getNetBeansShellScript(netbeansHome: URL?) -> String? {
        guard let netbeansHome = netbeansHome else {
            return nil
        }
        let netbeansShellScript = netbeansHome
            .appendingPathComponent("bin")
            .appendingPathComponent("netbeans")
            .path
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: netbeansShellScript)) {
            return netbeansShellScript
        }
        return nil
    }
    
    func selectNetBeansHome() -> URL? {
        return selectDirectory(title: "Please, select Apache NetBeans home directory!")
    }
    
    func alert(alertStyle: NSAlert.Style,messageText: String, informativeText: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

}

