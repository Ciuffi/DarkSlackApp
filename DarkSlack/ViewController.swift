//
//  ViewController.swift
//  DarkSlack
//
//  Created by Giulio Rossi on 2019-04-30.
//  Copyright © 2019 Giulio Rossi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var dropZone: DragView!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var SlackImage: NSImageView!
    @IBOutlet weak var StaticText: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        dropZone.delegate = self
        progress.startAnimation(self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: DragContainerDelegate {
    func draggingFileAccept(_ file: URL) {
        print("Accepted: \(file.absoluteString)")
    }
    func draggingFileDecline(_ file: URL) {
        print("Descline: \(file.absoluteString)")
    }
}
