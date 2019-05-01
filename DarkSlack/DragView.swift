//
//  DragView.swift
//  DarkSlack
//
//  Created by Giulio Rossi on 2019-04-30.
//  Copyright © 2019 Giulio Rossi. All rights reserved.
//

import Cocoa

protocol DragContainerDelegate {
    func draggingFileAccept(_ file: URL)
    func draggingFileDecline(_ file: URL)
    func draggingFileOk()
}

class DragView: NSView {
    
    var delegate: DragContainerDelegate?
    var defaultColor = NSColor(white: 255, alpha: 0)
    var draggedColor = NSColor(white: 1, alpha: 0.05)
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.wantsLayer = true
        self.layer?.backgroundColor = defaultColor.cgColor
        setup()
    }
    
    func setup(){
        registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeURL as String)])
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let acceptFiles = checkExtension(sender)
        if (acceptFiles) {
            self.layer?.backgroundColor = draggedColor.cgColor
            delegate?.draggingFileOk()
        }
        return acceptFiles ? NSDragOperation.generic : NSDragOperation()
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = defaultColor.cgColor
    }
    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = defaultColor.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue:"NSFilenamesPboardType")) as? [String] {
            let path = board[0]
            let url = URL(fileURLWithPath: path)
            if (url.lastPathComponent == "Slack.app"){
                delegate?.draggingFileAccept(url)
                return true
            }
        }
        return false
    }
    func checkExtension(_ draggingInfo: NSDraggingInfo) -> Bool {
        if let board = draggingInfo.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue:"NSFilenamesPboardType")) as? [String] {
            let path = board[0]
            let url = URL(fileURLWithPath: path)
            if (url.lastPathComponent == "Slack.app") {return true}
            delegate?.draggingFileDecline(url)
        }
        return false
    }
}
