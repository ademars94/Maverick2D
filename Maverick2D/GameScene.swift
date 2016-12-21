//
//  GameScene.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/19/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  var player = Player(x: 0, y: 0, angle: 0, speed: 7, plane: Plane(type: "spitfire"))
  var lastUpdatedTime: TimeInterval = 0.0
  
  var isTurningRight = false
  var isTurningLeft = false
  
  let map: SKSpriteNode = {
    let sprite = SKSpriteNode(imageNamed: "map")
    sprite.name = "map"
    sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    sprite.position = CGPoint(x: 0, y: 0)
    sprite.size = CGSize(width: 4096, height: 4096)
    sprite.physicsBody?.affectedByGravity = false
    sprite.zPosition = 1
    return sprite
  }()
  
  override func didMove(to view: SKView) {
    createPlane()
    createMap()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if touch.location(in: self).x < 0 {
        isTurningRight = false
        isTurningLeft = true
      }
      if touch.location(in: self).x > 0 {
        isTurningLeft = false
        isTurningRight = true
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if touch.location(in: self).x < 0 {
        isTurningRight = false
        isTurningLeft = true
      }
      if touch.location(in: self).x > 0 {
        isTurningLeft = false
        isTurningRight = true
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if touch.location(in: self).x < 0 {
        isTurningLeft = false
      }
      if touch.location(in: self).x > 0 {
        isTurningRight = false
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    if lastUpdatedTime == 0.0 {
      lastUpdatedTime = currentTime
    }
    
    let delta = currentTime - lastUpdatedTime
    print("Delta: \(delta)")
    
    var accumulatedFrames = round((currentTime - lastUpdatedTime) * 60)
    
    lastUpdatedTime = currentTime
    
    while accumulatedFrames > 0 {
      print("\(accumulatedFrames) accumulated")
      updateWorld()
      accumulatedFrames -= 1
    }
  }
  
  func updateWorld() {
    movePlane()
  }
  
  func movePlane() {
    let dx = player.x + CGFloat(player.speed * sin(M_PI / 180 * player.angle))
    let dy = player.y - CGFloat(player.speed * cos(M_PI / 180 * player.angle))
    
    if dx < 2048 && dx > -2048 {
      player.x = dx
    }
    
    if dy < 2048 && dy > -2048 {
      player.y = dy
    }
    
    if isTurningLeft {
      player.angle += 3
    } else if isTurningRight {
      player.angle -= 3
    }
    
    map.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    
    map.position.x = player.x
    map.position.y = player.y
    
    player.plane.zRotation = CGFloat(player.angle * M_PI / 180)
  }
  
  func createPlane() {
    player.plane.position = CGPoint(x: 0, y: 0)
    self.addChild(player.plane)
  }
  
  func createMap() {
    self.addChild(map)
  }
}
