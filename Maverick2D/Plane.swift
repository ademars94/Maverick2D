//
//  Plane.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/20/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

class Plane: SKSpriteNode {
  var health = 10
  var turningAbility = 3
  
  init(type: String) {
    let texture = SKTexture(imageNamed: type)
    super.init(texture: texture, color: .clear, size: CGSize(width: 128, height: 128))
    self.name = "plane"
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    self.position = CGPoint(x: 0, y: 0)
    self.physicsBody?.affectedByGravity = false
    self.zPosition = 10
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
