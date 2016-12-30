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
  var id: String = ""
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
//    print("-------------------------")
//    print("Name  : \(name)")
//    print("Id    : \(id)")
//    print("x     : \(x)")
//    print("y     : \(y)")
//    print("Angle : \(angle)")
//    print("Speed : \(speed)")
  }
  
  init(name:String, id: String, x: CGFloat, y: CGFloat, angle: Double, speed: Double, plane: Plane) {
    self.name = name
    self.id = id
    self.x = x
    self.y = y
    self.angle = angle
    self.speed = speed
    self.plane = plane
  }
}
