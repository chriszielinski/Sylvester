//
//  ViewController.swift
//  Sandbox
//
//  Created by Chris Zielinski on 12/22/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import Cocoa
import SourceKittenFramework

class ViewController: NSViewController {

    let testContents = """
                       import UIKit

                       class View: UIView {}
                       """

    @IBOutlet
    var textView: NSTextView!

    @IBAction
    func buttonAction(sender: NSButton) {
        textView.string = ""

        do {
            let editorOpen = try SylvesterInterface.customEditorOpen(file: File(contents: testContents))
            textView.string = editorOpen.debugDescription
        } catch {
            print(error)
            textView.string = (error as NSError).description
        }
    }

}
