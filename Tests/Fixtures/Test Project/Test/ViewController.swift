//
//  ViewController.swift
//  Test
//
//  Created by Chris Zielinski on 11/30/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import UIKit

/// This is the `ViewController`'s documentation.
///
/// It has another paragraph.
///
/// - Warning: And a warning callout.
///
class ViewController: UIViewController {

    /// This has some documentation also.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        try String(contentsOf: URL(fileURLWithPath: ""))
    }

    func genericFunction<T: RawRepresentable>(with parameter: T) -> ((T) -> String)? where T.RawValue == String {
        return nil
    }

}
