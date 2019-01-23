#!/usr/bin/swift
//
//  generate-docs.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 1/22/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import Foundation

let replacements: [String: String] = [
    "<span class=\"kt\">SKCodeCompletionSessionOptions</span>": "<span class=\"kt\"><a href=\"https://chriszielinski.github.io/Sylvester/SylvesterCommon/Structs/SKCodeCompletionSessionOptions.html\">SKCodeCompletionSessionResponse</a></span>",
    "<span class=\"kt\">SKError</span>": "<span class=\"kt\"><a href=\"https://chriszielinski.github.io/Sylvester/SylvesterCommon/Enums/SKError.html\">SKError</a></span>",
    "<span class=\"kt\">SKSubprocess</span>": "<span class=\"kt\"><a href=\"https://chriszielinski.github.io/Sylvester/SylvesterCommon/Structs/SKSubprocess.html\">SKSubprocess</a></span>"
]

func main() {
    guard let path = ProcessInfo.processInfo.arguments.last,
        let enumerator = FileManager.default.enumerator(atPath: path)
        else { print("Failed to create enumerator."); return }

    let pathURL = URL(fileURLWithPath: path)
    for file in enumerator {
        if let filePath = file as? String {
            let fileURL = pathURL.appendingPathComponent(filePath, isDirectory: false)

            guard fileURL.pathExtension == "html",
                var contents = try? String(contentsOf: fileURL)
                else { continue }

            print(fileURL.path)

            for replacement in replacements {
                contents = contents.replacingOccurrences(of: replacement.key, with: replacement.value)
            }

            do {
                try contents.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        }
    }
}

main()
