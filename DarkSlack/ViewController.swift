//
//  ViewController.swift
//  DarkSlack
//
//  Created by Giulio Rossi on 2019-04-30.
//  Copyright © 2019 Giulio Rossi. All rights reserved.
//

import Cocoa
import Alamofire

class ViewController: NSViewController {

    @IBOutlet weak var dropZone: DragView!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var SlackImage: NSImageView!
    @IBOutlet weak var StaticText: NSTextField!
    @IBOutlet weak var doneText: NSTextField!
    let ssbUrl = "https://raw.githubusercontent.com/caiceA/slack-black-theme/master/ssb-interop.js"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropZone.delegate = self
        progress.stopAnimation(self)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func DownloadSSB(_ filePath: URL) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let path = filePath.appendingPathComponent("Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js")
            return (path, [.removePreviousFile])
        }
        Alamofire.download(ssbUrl, to:
            destination).responseData { _ in
                self.progress.stopAnimation(self)
                self.doneText.isEnabled = true
        }
    }
}

extension ViewController: DragContainerDelegate {
    func draggingFileAccept(_ file: URL) {
        progress.startAnimation(self)
        DownloadSSB(file)
    }
    func draggingFileDecline(_ file: URL) {
        print("Descline: \(file.absoluteString)")
    }
}
