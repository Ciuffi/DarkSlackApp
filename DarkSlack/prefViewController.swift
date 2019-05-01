//
//  prefViewController.swift
//  DarkSlack
//
//  Created by Giulio Rossi on 2019-04-30.
//  Copyright © 2019 Giulio Rossi. All rights reserved.
//

import Cocoa

class prefViewController: NSViewController {

    
    @IBOutlet weak var urlSelector: NSPopUpButton!
    @IBOutlet weak var customText: NSTextField!
    var selectedPopUp: String?
    var prefs: Preferences = Preferences()
    override func viewDidLoad() {
        super.viewDidLoad()
        urlSelector.selectItem(withTitle: prefs.url)
        if prefs.url == "Custom" {
            customText.isEnabled = true
        }
        customText.stringValue = prefs.customURL
        // Do view setup here.
    }
    
    @IBAction func OKClicked(_ sender: Any) {
        prefs.url = selectedPopUp ?? prefs.url
        prefs.customURL = customText.stringValue
        view.window?.close()
    }
    @IBAction func CancelClicked(_ sender: Any) {
        view.window?.close()
    }
    @IBAction func OnButtonChange(_ sender: NSPopUpButton) {
        if (sender.selectedItem?.title == "Custom") {
            customText.isEnabled = true;
        }else{
            customText.isEnabled = false;
        }
        selectedPopUp = sender.selectedItem?.title
    }
}
