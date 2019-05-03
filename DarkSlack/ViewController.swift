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
    
    func showError(_ error: String){
        self.errorText.stringValue = error
        self.errorText.isHidden = false
        NSSound.beep()
    }
    func copySSBFile(_ inPath: URL, _ outPath: URL) {
        try? FileManager.default.removeItem(at: outPath)
        do {
            try FileManager.default.moveItem(at: inPath, to: outPath)
            doneText.isHidden = false
        }catch {
            showError("Unable to move file to into slack app")
        }
        progress.stopAnimation(self)
    }
    
    func DownloadSSB(_ appPath: URL, _ callback: @escaping (_ inPath: URL, _ outPath: URL) -> Void) {
        var prefs = Preferences()
        var ssbURL: String?
        if (prefs.url == "Custom"){
            ssbURL = prefs.customURL
        }else{
            ssbURL = prefs.url
        }
    let filePath = appPath.appendingPathComponent("Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("ssb-interop.js")
            
            return (fileURL, [.removePreviousFile])
        }
        Alamofire.download(ssbURL!, to: destination).responseData {response in
                switch response.result {
                case .failure(let error):
                    self.showError("Failed to download file: \(ssbURL!)")
                    print(error)
                case .success(_):
                    let inPath: URL = URL(fileURLWithPath: response.destinationURL!.path)
                    callback(inPath, filePath)
                }
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
        DownloadSSB(file, copySSBFile(_:_:))
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
