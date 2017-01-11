//
//  SocketController.swift
//  Maverick2D
//
//  Created by Alex DeMars on 1/11/17.
//  Copyright © 2017 Alex DeMars. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

protocol SocketControllerDelegate {
  func correctPlayerPosition(player: [String: Any])
  func updatePlayerPositions(players: [[String: Any]])
}

class SocketController: NSObject, GCDAsyncUdpSocketDelegate {
  var socket: GCDAsyncUdpSocket?
  var delegate: SocketControllerDelegate?
  var tag = 1
  var localPort: UInt16 = 0000
  var hostUrl = "172.24.32.15"
  var hostPort: UInt16 = 1337
  
  init(delegate: SocketControllerDelegate) {
    super.init()
    self.socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
    self.delegate = delegate
  }
  
  // ======================
  // MARK: - Custom Methods
  // ======================
  
  func createSocket(completion: () -> ()) {
    guard let socket = self.socket else {
      print("Could not create socket.")
      return
    }
    
    do {
      try socket.bind(toPort: socket.connectedPort())
      print("Socket bound to \(socket.connectedPort())!")
    } catch(let error) {
      print(error.localizedDescription)
      return
    }
    
    do {
      try socket.beginReceiving()
      print("Socket is recieving!")
    } catch(let error) {
      print(error.localizedDescription)
    }
    
    self.localPort = socket.localPort()
    completion()
  }
  
  func sendSocketMessage(playerState: [String: Any]) {
    guard let socket = self.socket else {
      print("Could not unwrap socket.")
      return
    }
    
    if JSONSerialization.isValidJSONObject(playerState) {
      guard let data = try? JSONSerialization.data(withJSONObject: playerState, options: .prettyPrinted) else {
        print("Exiting in guard. Could not create JSON object from playerState.")
        return
      }
      
      socket.send(data, toHost: hostUrl, port: hostPort, withTimeout: 10, tag: self.tag)
      self.tag += 1
    } else {
      print("playerState is not a valid JSON object.")
    }
  }
  
  // ========================
  // MARK: - Delegate Methods
  // ========================
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
    
  }
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
    guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      print("Got message but could not serialize JSON.")
      return
    }
    
    print("------------- SOCKET MESSAGE --------------")
    
    // If data is a dictionary, else if data is an array of dictionaries
    if let serverData = json as? [String: Any] {
      if let type = serverData["type"] as? String {
        switch type {
        case "correction": self.delegate?.correctPlayerPosition(player: serverData)
        default: return
        }
      }
    } else if let serverData = json as? [[String: Any]] {
      self.delegate?.updatePlayerPositions(players: serverData)
    } else {
      print("ERROR: Could not evaluate data.")
    }
    
  }
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
    guard let error = error else {
      return
    }
    
    print("Socket failed to connect with error:")
    print(error.localizedDescription)
  }
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
    print("didConnectToAddress")
  }
  
  func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
    guard let error = error else {
      return
    }
    
    print("Socket closed with error:")
    print(error.localizedDescription)
  }
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
    guard let error = error else {
      return
    }
    
    print("Failed to send data with error:")
    print(error.localizedDescription)
  }
}
