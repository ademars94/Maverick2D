//
//  AnalogStick.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/27/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

class AnalogStick: SKSpriteNode {
  
  let base: SKShapeNode = {
    let node = SKShapeNode(circleOfRadius: 128)
    node.fillColor = UIColor(red: 70, green: 70, blue: 70, alpha: 1)
    node.strokeColor = .clear
    node.name = "base"
    return node
  }()
  
  let stick: SKShapeNode = {
    let node = SKShapeNode(circleOfRadius: 64)
    node.fillColor = UIColor(red: 120, green: 120, blue: 120, alpha: 1)
    node.strokeColor = .clear
    node.name = "stick"
    return node
  }()
  
  init(position: CGPoint) {
    super.init(texture: nil, color: .clear, size: CGSize(width: 128, height: 128))
    self.position = position
    self.isUserInteractionEnabled = true
    self.addChild(base)
    self.addChild(stick)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func moveThumbTo(position: CGPoint) {
    if base.contains(position) {
      stick.position = position
    } else {
      let dx = position.x - base.position.x
      let dy = position.y - base.position.y
      let angle = atan2(dy, dx)
      
      let x = (128 * cos(angle)) + base.position.x
      let y = (128 * sin(angle)) + base.position.y
      
      stick.position = CGPoint(x: x, y: y)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      moveThumbTo(position: touch.location(in: self))
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    moveThumbTo(position: CGPoint(x: 0, y: 0))
  }
  
}

extension CGPoint {
  func distanceFromCGPoint(point:CGPoint)->CGFloat{
    return sqrt(pow(self.x - point.x,2) + pow(self.y - point.y,2))
  }
}
