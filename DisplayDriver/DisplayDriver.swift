//
//  DisplayDriver.swift
//  DisplayDriver
//
//  Created by Vitor Silva on 08/11/19.
//  Copyright © 2019 Vitor Silva. All rights reserved.
//

import Cocoa

class DisplayDriverIcon {
    var item: NSStatusItem! = nil
    var menu = NSMenu()
    let id: CGDirectDisplayID
    var modes: [CGDisplayMode]
    var nameToMode: [String: CGDisplayMode] = [:]
    
    init() {
        // Get the main display id
        id = CGMainDisplayID()
        self.modes = []
        // Discover display modes supported
        let modes = CGDisplayCopyAllDisplayModes(id, nil)! as NSArray
        for i in modes {
            // Save supported modes in the mode array
            self.modes.append(i as! CGDisplayMode)
        }
    }
    
    func create() {
        // Create a system menu bar item
        let bar = NSStatusBar.system
        // Add some style
        item = bar.statusItem(withLength: 38)
        item.isVisible = true
        item.button!.title = "🖥"
        
        // Create the menu to select the modes
        prepareMenu()
        item.menu = menu
        
        // Enable the exit by removing the program
        item.behavior = .terminationOnRemoval
    }
    
    func prepareMenu() {
        // Create the first menu item
        let title = "restore"
        let item = NSMenuItem(title: title, action: #selector(hello), keyEquivalent: "")
        item.target = self
        menu.addItem(item)
        
        // Iterate over screen modes to add to menu
        for mode in modes {
            let title = "\(mode.pixelWidth)x\(mode.pixelHeight)"
            // Set the callback
            let item = NSMenuItem(title: title, action: #selector(hello), keyEquivalent: "")
            item.target = self
            nameToMode[title] = mode
            menu.addItem(item)
        }
    }
    
    @objc func hello(_ item: NSMenuItem) {
        if item.title == "restore" {
            CGRestorePermanentDisplayConfiguration()
        } else {
            CGDisplaySetDisplayMode(id, nameToMode[item.title], nil)
        }
    }
}
