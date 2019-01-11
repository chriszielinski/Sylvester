//
//  SylvesterXPCDelegate.swift
//  SylvesterXPCService 😼
//
//  Created by Chris Zielinski on 9/15/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import Cocoa

class SylvesterXPCDelegate: NSObject {}

// MARK: - XPC Listener Delegate Protocol

extension SylvesterXPCDelegate: NSXPCListenerDelegate {

    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = SylvesterXPCService()
        newConnection.exportedInterface = NSXPCInterface(with: SylvesterXPCProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }

}
