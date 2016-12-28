//
//  Player.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/20/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

class Player {
  var x: CGFloat = 0
  var y: CGFloat = 0
  var angle: Double = 0
  var speed: Double = 0
  var plane: Plane
  
  init(x: CGFloat, y: CGFloat, angle: Double, speed: Double, plane: Plane) {
    self.x = x
    self.y = y
    self.angle = angle
    self.speed = speed
    self.plane = plane
  }
}
