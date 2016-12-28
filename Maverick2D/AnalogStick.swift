//
//  AnalogStick.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/27/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

class AnalogStick: SKSpriteNode {
  
  var isTurningRight = false
  var isTurningLeft = false
  var radius = CGFloat()
  
  lazy var base: SKShapeNode = {
    let node = SKShapeNode(circleOfRadius: self.radius)
    node.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    node.lineWidth = 0
    node.name = "base"
    return node
  }()
  
  lazy var stick: SKShapeNode = {
    let node = SKShapeNode(circleOfRadius: self.radius / 2)
    node.fillColor = UIColor(red:0.8, green:0, blue:0, alpha:1.0)
    node.lineWidth = 0
    node.name = "stick"
    return node
  }()
  
  init(position: CGPoint, radius: CGFloat) {
    super.init(texture: nil, color: .clear, size: CGSize(width: radius, height: radius))
    self.position = position
    self.radius = radius
    self.isUserInteractionEnabled = true
    self.addChild(base)
    self.addChild(stick)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func moveStickTo(position: CGPoint) {
    if base.contains(position) {
      stick.position = position
    } else {
      let dx = position.x - base.position.x
      let dy = position.y - base.position.y
      let angle = atan2(dy, dx)
      
      let x = (radius * cos(angle)) + base.position.x
      let y = (radius * sin(angle)) + base.position.y
      
      stick.position = CGPoint(x: x, y: y)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      moveStickTo(position: touch.location(in: self))
      if touch.location(in: self).x < 0 {
        isTurningRight = false
        isTurningLeft = true
      } else if touch.location(in: self).x > 0 {
        isTurningLeft = false
        isTurningRight = true
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    moveStickTo(position: CGPoint(x: 0, y: 0))
    isTurningLeft = false
    isTurningRight = false
  }
  
}

extension CGPoint {
  func distanceFromCGPoint(point:CGPoint)->CGFloat{
    return sqrt(pow(self.x - point.x,2) + pow(self.y - point.y,2))
  }
}
