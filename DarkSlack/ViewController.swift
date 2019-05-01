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

    @IBOutlet weak var errorText: NSTextField!
    @IBOutlet weak var dropZone: DragView!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var SlackImage: NSImageView!
    @IBOutlet weak var StaticText: NSTextField!
    @IBOutlet weak var doneText: NSTextField!
    
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
        var prefs = Preferences()
        var ssbURL: String?
        if (prefs.url == "custom"){
            ssbURL = prefs.customURL
        }else{
            ssbURL = prefs.url
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let path = filePath.appendingPathComponent("Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js")
            return (path, [.removePreviousFile])
        }
        Alamofire.download(ssbURL!, to:
            destination).responseData { _ in
                self.progress.stopAnimation(self)
                self.doneText.isHidden = false
                print("Successfully downloaded from url \(ssbURL!)")
        }
    }
}

extension ViewController: DragContainerDelegate {
    func draggingFileOk(){
        errorText.isHidden = true
    }
    func draggingFileAccept(_ file: URL) {
        errorText.isHidden = true
        progress.startAnimation(self)
        DownloadSSB(file)
    }
    func draggingFileDecline(_ file: URL) {
        errorText.isHidden = false;
    }
}
