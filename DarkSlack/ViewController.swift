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
    
    func showError(_ error: String){
        self.errorText.stringValue = error
        self.errorText.isHidden = false
    }
    
    func DownloadSSB(_ filePath: URL) {
        var prefs = Preferences()
        var ssbURL: String?
        if (prefs.url == "Custom"){
            ssbURL = prefs.customURL
        }else{
            ssbURL = prefs.url
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let path = filePath.appendingPathComponent("Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js")
            return (path, [.removePreviousFile])
        }
        Alamofire.download(ssbURL!, to:
            destination).responseData {response in
                switch response.result {
                case .failure:
                    self.showError("Failed to download file: \(ssbURL!)")
                case .success(_):
                    self.doneText.isHidden = false
                }
                self.progress.stopAnimation(self)
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
        doneText.isHidden = true
        self.showError("File is not the Slack App")
    }
}

extension ViewController {
    @IBAction func selectSlackFile(_sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose your Slack App";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["app"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if (result != nil) {
                let path = result!.path
                let url = URL(fileURLWithPath: path)
                (url.lastPathComponent == "Slack.app") ? draggingFileAccept(url) : draggingFileDecline(url)
            }
        } else {
            return
        }
    }
}
