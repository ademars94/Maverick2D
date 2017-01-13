//
//  AnalogStick.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/27/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

protocol AnalogStickDelegate {
  func fire() -> Void
  func didEndTracking() -> Void
}

class AnalogStick: SKSpriteNode {

  var deltaX: Double = 0.0
  var deltaY: Double = 0.0
  var isTracking = false
  var radius = CGFloat()
  var delegate: AnalogStickDelegate?
  
  lazy var sensor: SKShapeNode = {
    let node = SKShapeNode(circleOfRadius: self.radius)
    node.fillColor = .clear
    node.lineWidth = 0
    node.name = "sensor"
    return node
  }()
  
  lazy var base: SKShapeNode = {
    let node = SKShapeNode(circleOfRadius: self.radius * 1.5)
    node.fillColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha:1)
    node.lineWidth = 0
    node.name = "base"
    return node
  }()
  
  lazy var stick: SKShapeNode = {
    let node = SKShapeNode(circleOfRadius: self.radius * 0.8)
    node.fillColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha:1)
    node.strokeColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha:1)
    node.lineWidth = 3
    node.name = "stick"
    return node
  }()
  
  init(position: CGPoint, radius: CGFloat, delegate: AnalogStickDelegate) {
    super.init(texture: nil, color: .clear, size: CGSize(width: radius, height: radius))
    self.delegate = delegate
    self.position = position
    self.radius = radius
    self.isUserInteractionEnabled = true
    self.addChild(base)
    self.addChild(sensor)
    self.addChild(stick)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func moveStickTo(position: CGPoint) {
    if sensor.contains(position) {
      self.stick.position = position
    } else {
      let dx = position.x - sensor.position.x
      let dy = position.y - sensor.position.y
      let angle = atan2(dy, dx)
      
      let x = (radius * cos(angle)) + sensor.position.x
      let y = (radius * sin(angle)) + sensor.position.y
      
      self.stick.position = CGPoint(x: x, y: y)
    }
  
    setStickDelta()
  }
  
  func roundValue(_ value: Double, toNearest: Double) -> Double {
    return round(value / toNearest) * toNearest
  }
  
  func setStickDelta() {
    let percentX = Double(self.stick.position.x) / Double(self.radius)
    let percentY = Double(self.stick.position.y) / Double(self.radius)
    
    self.deltaX = roundValue(percentX, toNearest: 0.01)
    self.deltaY = roundValue(percentY, toNearest: 0.01)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.isTracking = true
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      moveStickTo(position: touch.location(in: self))
      if touch.force > 5 {
        self.delegate?.fire()
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let returnToCenter = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.05)
    stick.run(returnToCenter) { _ in
      self.setStickDelta()
      self.isTracking = false
      self.delegate?.didEndTracking()
    }
  }
  
}

extension CGPoint {
  func distanceFromCGPoint(point:CGPoint)->CGFloat{
    return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y ,2))
  }
}
