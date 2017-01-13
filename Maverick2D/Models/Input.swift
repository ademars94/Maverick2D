//
//  Input.swift
//  Maverick2D
//
//  Created by Alex DeMars on 1/13/17.
//  Copyright © 2017 Alex DeMars. All rights reserved.
//

import Foundation

class Input: NSObject {
  
  var id: UInt16
  var turnDelta: Double
  var frameNumber: Int
  
  init(id: UInt16, turnDelta: Double, frameNumber: Int) {
    self.id = id
    self.turnDelta = turnDelta
    self.frameNumber = frameNumber
  }
  
  func toStringAny() -> [String: Any] {
    let unserialized: [String: Any] = ["id": self.id, "type": "input", "turnDelta": self.turnDelta, "frameNumber": self.frameNumber]
    return unserialized
  }
  
}
