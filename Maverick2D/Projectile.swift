//
//  Projectile.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/28/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

class Projectile: SKSpriteNode {
  var damage = 1
  var x: CGFloat = 0
  var y: CGFloat = 0
  var angle: Double = 0
  var velocity: Double = 10
  
  init(type: String, angle: Double, x: CGFloat, y: CGFloat) {
    let texture = SKTexture(imageNamed: type)
    super.init(texture: texture, color: .clear, size: CGSize(width: 32, height: 32))
    self.name = "projectile"
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    self.position = CGPoint(x: 0, y: 0)
    self.physicsBody?.affectedByGravity = false
    self.zPosition = 10
    self.angle = angle
    self.x = x
    self.y = y
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
