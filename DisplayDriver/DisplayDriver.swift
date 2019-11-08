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
        id = CGMainDisplayID()
        self.modes = []
        let modes = CGDisplayCopyAllDisplayModes(id, nil) as! NSArray
        for i in modes {
            self.modes.append(i as! CGDisplayMode)
        }
    }
    
    func create() {
        let bar = NSStatusBar.system
        item = bar.statusItem(withLength: 38)
        item.isVisible = true
        item.button!.title = "🖥"
        
        prepareMenu()
        item.menu = menu
        item.behavior = .terminationOnRemoval
    }
    
    func prepareMenu() {
        for mode in modes {
            let title = "\(mode.pixelWidth)x\(mode.pixelHeight)"
            let item = NSMenuItem(title: title, action: #selector(hello), keyEquivalent: "")
            item.target = self
            nameToMode[title] = mode
            menu.addItem(item)
        }
    }
    
    @objc func hello(_ item: NSMenuItem) {
        CGDisplaySetDisplayMode(id, nameToMode[item.title], nil)
    }
}
