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
  var plane: Plane = Plane(type: "mustang")
  var speed: Double = 0
  
  var x: CGFloat = 0
  var y: CGFloat = 0
  var angle: Double = 0
  
  var nextX: CGFloat = 0
  var nextY: CGFloat = 0
  var nextAngle: Double = 0
  
  var lastKnownX: CGFloat = 0
  var lastKnownY: CGFloat = 0
  var lastKnownAngle: Double = 0
  
  var dx: CGFloat = 0
  var dy: CGFloat = 0
  var da: Double = 0
  
  var stepX: CGFloat = 0
  var stepY: CGFloat = 0
  var stepAngle: Double = 0
  
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
  
  func executeStep() {
    self.x += self.stepX
    self.y += self.stepY
    self.angle += self.stepAngle
    
    self.dx = self.dx - self.stepX
    self.dy = self.dy - self.stepY
    self.da = self.da - self.stepAngle
    
    print("Step X  : \(stepX)")
    print("Delta X : \(dx)")
  }
  
  func setLastKnownPosition() {
    self.lastKnownX = self.nextX
    self.lastKnownY = self.nextY
    self.lastKnownAngle = self.nextAngle
    
    self.x = self.lastKnownX
    self.y = self.lastKnownY
    self.angle = self.lastKnownAngle
  }
  
  func processNextPositon(point: CGPoint, angle: Double) {
    self.nextX = point.x
    self.nextY = point.y
    self.nextAngle = angle
    
    self.dx = point.x - self.x
    self.dy = point.y - self.y
    self.da = angle - self.angle
    
    self.stepX = dx / 3
    self.stepY = dy / 3
    self.stepAngle = da / 3
  }
}
