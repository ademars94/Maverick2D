//
//  Player.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/20/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

class Player: NSObject {
  var name: String = ""
  var id: UInt16 = 0
  var x: CGFloat = 0
  var y: CGFloat = 0
  var angle: Double = 0
  var speed: Double = 0
  var plane: Plane = Plane(type: "spitfire")
  
  override func setValue(_ value: Any?, forKey key: String) {
    if !self.responds(to: Selector(key)) {
      return
    }
    super.setValue(value, forKey: key)
  }
  
  init(playerDictionary: [String: Any]) {
    super.init()
    setValuesForKeys(playerDictionary)
  }
  
  init(name:String, id: UInt16, x: CGFloat, y: CGFloat, angle: Double, speed: Double, plane: Plane) {
    self.name = name
    self.id = id
    self.x = x
    self.y = y
    self.angle = angle
    self.speed = speed
    self.plane = plane
  }
  
  func movePlane(to point: CGPoint, angle: Double) {
    self.x = point.x
    self.y = point.y
    self.plane.position = point
    self.angle = angle
    self.plane.zRotation = CGFloat(angle * M_PI / 180)
  }
}
