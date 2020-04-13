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
    //
    var modes: [CGDirectDisplayID: [CGDisplayMode]] = [:]
    var nameToMode: [String: CGDisplayMode] = [:]
    
    init() {
        refresh()
    }
    
    // Update modes values
    func refresh() {
        modes = [:]
        
        // get displays
        let displays = getDisplays()
        
        // get displays configurations
        for display in displays {
            // get configuration
            let currentDisplayModes = CGDisplayCopyAllDisplayModes(display, nil)! as NSArray
            // push to the dictionary
            for mode in currentDisplayModes {
                if modes[display] != nil {
                    modes[display]!.append(mode as! CGDisplayMode)
                } else {
                    modes[display] = [mode as! CGDisplayMode]
                }
            }
            
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
        let restore = ConfigurationMenuItem(title: "Restore", action: #selector(setMode), keyEquivalent: "")
        restore.restore = true
        restore.target = self
        menu.addItem(restore)
        
        let refresh = ConfigurationMenuItem(title: "Refresh", action: #selector(setMode), keyEquivalent: "")
        refresh.refresh = true
        refresh.target = self
        menu.addItem(refresh)
        
        for display in modes.keys {
            // Add display name
            menu.addItem(NSMenuItem.separator())
            let item = ConfigurationMenuItem(title: screenName(for: display), action: nil, keyEquivalent: "")
            item.isEnabled = false
            menu.addItem(item)
            
            for mode in modes[display]! {
                let title = "\(mode.pixelWidth)x\(mode.pixelHeight)"
                
                // Set the callback
                let item = ConfigurationMenuItem(title: title, action: #selector(setMode), keyEquivalent: "")
                    
                // Add the metadata
                item.display = display
                item.mode = mode
                item.target = self
                
                // Add to menu
                menu.addItem(item)
            }
        }
        
        // Iterate over screen modes to add to menu
        /*for mode in modes {
            let title = "\(mode.pixelWidth)x\(mode.pixelHeight)"
            // Set the callback
            let item = NSMenuItem(title: title, action: #selector(hello), keyEquivalent: "")
            item.target = self
            nameToMode[title] = mode
            menu.addItem(item)
        }*/
    }
    
    @objc func setMode(_ item: ConfigurationMenuItem) {
        if item.display != nil {
            CGDisplaySetDisplayMode(item.display!, item.mode, nil)
        } else {
            if item.restore {
                CGRestorePermanentDisplayConfiguration()
            } else if item.refresh {
                menu.removeAllItems()
                refresh()
                prepareMenu()
            }
        }
    }
    
    func getDisplays() -> [CGDirectDisplayID] {
        // hardcoded maxdisplays
        let maxDisplays = 128
        
        // Arguments to c functions
        // This holds the returned array of displays
        var displays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: maxDisplays)
        
        defer {
            displays.deallocate()
        }
        
        // This one how many were returned
        var displaysCount = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        
        defer {
            displaysCount.deallocate()
        }
        
        // Get displays
        let ret = CGGetActiveDisplayList(UInt32(maxDisplays), displays, displaysCount)
        
        if ret == CGError.success {
            let count = displaysCount.pointee
            var currentReference = displays
            var activeDisplays = [CGDirectDisplayID]()
            
            for _ in 0..<count {
                activeDisplays.append(currentReference.pointee)
                currentReference = currentReference.successor()
            }
            
            return activeDisplays
        }
        
        // Something went wrong
        return []
        
    }
    
    func screenName(for display: CGDirectDisplayID) -> String {
        var screenName = "Unknown"
        
        let deviceInfo = IODisplayCreateInfoDictionary(IOServicePortFromCGDisplayID(display), IOOptionBits(kIODisplayOnlyPreferredName)).takeRetainedValue() as NSDictionary
        let localizedNames = deviceInfo[kDisplayProductName] as? NSDictionary ?? NSDictionary()

        if localizedNames.count > 0 {
            screenName = localizedNames[localizedNames.allKeys.first!] as! String
        }

        return screenName;
    }
    
    
}

class ConfigurationMenuItem: NSMenuItem {
    var display: CGDirectDisplayID?
    var mode: CGDisplayMode?
    var refresh = false
    var restore = false
}
