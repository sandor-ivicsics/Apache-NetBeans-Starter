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
    @IBOutlet weak var textFieldNetBeansJDKHome: NSTextField!
    @IBOutlet weak var buttonBrowseForNetBeansJDKHome: NSButton!
    @IBOutlet weak var textFieldNetBeansHome: NSTextField!
    @IBOutlet weak var buttonBrowseForNetBeansHome: NSButton!
    
    @IBAction func browseForNetBeansJDKHome(_ sender: Any) {
        if let jdkHome = selectJDKHome() {
            if isValidJDKHome(jdkHome: jdkHome) {
                textFieldNetBeansJDKHome.stringValue = jdkHome
            } else {
                alert(alertStyle: .critical, messageText: "Invalid JDK home directory!", informativeText: "Invalid JDK home directory!")
            }
        }
    }
    
    @IBAction func browseForNetBeansHome(_ sender: Any) {
        if let netbeansHome = selectNetBeansHome() {
            if isValidNetBeansHome(netbeansHome: netbeansHome) {
                textFieldNetBeansHome.stringValue = netbeansHome.path
            } else {
                alert(alertStyle: .critical, messageText: "Invalid Apache NetBeans home directory!", informativeText: "Invalid Apache NetBeans home directory!")
            }
        }
    }
    
    @IBAction func startNetBeans(_ sender: Any) {
        let netbeansJDKHome = textFieldNetBeansJDKHome.stringValue
        if netbeansJDKHome.isEmpty {
            alert(alertStyle: .critical, messageText: "Invalid JDK home directory!", informativeText: "Invalid JDK home directory!")
            return
        }
        let netbeansHome = textFieldNetBeansHome.stringValue
        if netbeansHome.isEmpty {
            alert(alertStyle: .critical, messageText: "Invalid Apache NetBeans home directory!", informativeText: "Invalid Apache NetBeans home directory!")
            return
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(netbeansJDKHome, forKey: "netbeans_jdkhome")
        userDefaults.set(URL(fileURLWithPath: netbeansHome), forKey: "netbeans_home")
        if startNetBeans() {
            NSApplication.shared.terminate(self)
        } else {
            alert(alertStyle: .critical, messageText: "Failed to start Apache NetBeans!", informativeText: "Failed to start Apache NetBeans!")
        }
    }
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if startNetBeans() {
            NSApplication.shared.terminate(self)
            return
        }
        let userDefaults = UserDefaults.standard
        let environment = ProcessInfo.processInfo.environment
        var netbeansJDKHome = environment["netbeans_jdkhome"]
        var validNetbeansJDKHomeFromEnvironment = false
        if isValidJDKHome(jdkHome: netbeansJDKHome) {
             validNetbeansJDKHomeFromEnvironment = true
        } else {
            netbeansJDKHome = userDefaults.string(forKey: "netbeans_jdkhome")
        }
        textFieldNetBeansJDKHome.stringValue = netbeansJDKHome ?? ""
        buttonBrowseForNetBeansJDKHome.isEnabled = !validNetbeansJDKHomeFromEnvironment
        let netbeansHome = userDefaults.url(forKey: "netbeans_home")
        textFieldNetBeansHome.stringValue = netbeansHome?.path ?? ""
        window.setIsVisible(true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
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
    
    func isValidJDKHome(jdkHome: String) -> Bool {
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
    
    func isValidJDKHome(jdkHome: String?) -> Bool {
        guard let jdkHome = jdkHome else {
            return false
        }
        return isValidJDKHome(jdkHome: jdkHome)
    }
    
    func selectJDKHome() -> String? {
        guard let jdkHome = selectDirectory(title: "Please, select JDK home directory!", initialDirectory: "/Library/Java/JavaVirtualMachines") else {
            return nil
        }
        return jdkHome.path
    }
    
    func generateNetBeansShellScriptPath(netbeansHome: URL) -> String {
        let netbeansShellScript = netbeansHome
            .appendingPathComponent("bin")
            .appendingPathComponent("netbeans")
            .path
        return netbeansShellScript
    }
    
    func isValidNetBeansHome(netbeansHome: URL) -> Bool {
        let netbeansShellScript = generateNetBeansShellScriptPath(netbeansHome: netbeansHome)
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: netbeansShellScript)
    }
    
    func getNetBeansShellScript(netbeansHome: URL?) -> String? {
        guard let netbeansHome = netbeansHome else {
            return nil
        }
        let netbeansShellScript = generateNetBeansShellScriptPath(netbeansHome: netbeansHome)
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
    
    func startNetBeans() -> Bool {
        let userDefaults = UserDefaults.standard
        var environment = ProcessInfo.processInfo.environment
        var netbeansJDKHome = environment["netbeans_jdkhome"]
        if isValidJDKHome(jdkHome: netbeansJDKHome) {
            print("netbeansJDKHome from environment: \(environment["netbeans_jdkhome"] as Optional)")
        } else {
            netbeansJDKHome = userDefaults.string(forKey: "netbeans_jdkhome")
            if isValidJDKHome(jdkHome: netbeansJDKHome) {
                let netbeansHome = userDefaults.url(forKey: "netbeans_home")
                guard let netbeansShellScript = getNetBeansShellScript(netbeansHome: netbeansHome) else {
                    return false
                }
                let process = Process()
                process.environment = environment
                guard let shell = environment["SHELL"] else {
                    return false
                }
                process.executableURL = URL(fileURLWithPath: shell)
                process.arguments = [netbeansShellScript]
                do {
                    try process.run()
                    return true
                } catch {
                    print("Unexpected error: \(error).")
                }
            }
        }
        return false
    }

}

