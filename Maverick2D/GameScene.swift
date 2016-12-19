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
  
  let zero: SKSpriteNode = {
    let sprite = SKSpriteNode(imageNamed: "zero")
    sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    sprite.size = CGSize(width: 128, height: 128)
    sprite.physicsBody?.affectedByGravity = false
    sprite.zPosition = 10
    
    return sprite
  }()
  
  override func didMove(to view: SKView) {
    createMap()
    self.addChild(zero)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func update(_ currentTime: TimeInterval) {
    
  }
  
  func createMap() {
    let map = SKSpriteNode(imageNamed: "map")
    map.name = "map"
    map.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    map.position = CGPoint(x: 0, y: 0)
    map.size = CGSize(width: 4096, height: 4096)
    map.physicsBody?.affectedByGravity = false
    map.zPosition = 1
    self.addChild(map)
  }
  
  func moveMap() {
  
  }
}
