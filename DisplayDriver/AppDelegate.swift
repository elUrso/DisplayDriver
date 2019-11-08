//
//  AppDelegate.swift
//  DisplayDriver
//
//  Created by Vitor Silva on 08/11/19.
//  Copyright © 2019 Vitor Silva. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var icon: DisplayDriverIcon! = nil


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        icon = DisplayDriverIcon()
        icon.create()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

