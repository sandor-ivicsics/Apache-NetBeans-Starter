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
        var environment = ProcessInfo.processInfo.environment
        var netbeansJDKHome = environment["netbeans_jdkhome"]
        if isValidJDKHome(jdkHome: netbeansJDKHome) {
            print("netbeansJDKHome from environment: \(environment["netbeans_jdkhome"] as Optional)")
        } else {
            netbeansJDKHome = userDefaults.string(forKey: "netbeans_jdkhome")
            if !isValidJDKHome(jdkHome: netbeansJDKHome) {
                // TODO
                //netbeansJDKHome = getInstalledJDKHome(installedJDK: selectInstalledJDK())
                netbeansJDKHome = selectJDKHome()
                if !isValidJDKHome(jdkHome: netbeansJDKHome) {
                    alert(alertStyle: .critical, messageText: "Invalid JDK home directory!", informativeText: "Invalid JDK home directory!")
                    window.setIsVisible(true)
                    return
                }
                userDefaults.set(netbeansJDKHome, forKey: "netbeans_jdkhome")
            }
            print("netbeansJDKHome: \(netbeansJDKHome as Optional)")
            environment["netbeans_jdkhome"] = netbeansJDKHome
        }
        var netbeansHome = userDefaults.url(forKey: "netbeans_home")
        var netbeansShellScript = getNetBeansShellScript(netbeansHome: netbeansHome)
        if netbeansShellScript == nil {
            netbeansHome = selectNetBeansHome()
            netbeansShellScript = getNetBeansShellScript(netbeansHome: netbeansHome)
            if netbeansShellScript == nil {
                alert(alertStyle: .critical, messageText: "Invalid Apache NetBeans home directory!", informativeText: "Invalid Apache NetBeans home directory!")
                window.setIsVisible(true)
                return
            }
            userDefaults.set(netbeansHome, forKey: "netbeans_home")
        }
        print("netbeansShellScript: \(netbeansShellScript as Optional)")
        let process = Process()
        process.environment = environment
        guard let shell = environment["SHELL"] else {
            return
        }
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
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
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
    
    func selectDirectory(title: String, initialDirectory: String?) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.title = title
        if initialDirectory != nil {
            openPanel.directoryURL = URL(fileURLWithPath: initialDirectory!)
        }
        if (openPanel.runModal() != .OK) {
            return nil
        }
        return openPanel.urls.first
    }
    
    func isValidJDKHome(jdkHome: String?) -> Bool {
        guard let jdkHome = jdkHome else {
            return false
        }
        /*let java = URL(fileURLWithPath: jdkHome)
            .appendingPathComponent("jre")
            .appendingPathComponent("bin")
            .appendingPathComponent("java")
            .path*/
        let javac = URL(fileURLWithPath: jdkHome)
            .appendingPathComponent("bin")
            .appendingPathComponent("javac")
            .path
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: javac)
    }
    
    func selectJDKHome() -> String? {
        guard let jdkHome = selectDirectory(title: "Please, select JDK home directory!", initialDirectory: "/Library/Java/JavaVirtualMachines") else {
            return nil
        }
        return jdkHome.path
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
        return selectDirectory(title: "Please, select Apache NetBeans home directory!", initialDirectory: nil)
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

