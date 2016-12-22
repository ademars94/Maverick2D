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
  
  var tileMap = SKTileMapNode()
  
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
    createTileMap()
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
  
  func createPlane() {
    player.plane.position = CGPoint(x: 0, y: 0)
    self.addChild(player.plane)
  }
  
  func createTileMap() {
    let waterTile = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-1"))
    let waterTileGroup = SKTileGroup(tileDefinition: waterTile)
    
    let landTile64 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-64"))
    let landTile63 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-63"))
    let landTile56 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-56"))
    let landTile55 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-55"))
    let landTile54 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-54"))
    let landTile53 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-53"))
    let landTile48 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-48"))
    let landTile47 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-47"))
    let landTile46 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-46"))
    let landTile45 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-45"))
    let landTile44 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-44"))
    let landTile43 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-43"))
    let landTile40 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-40"))
    let landTile39 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-39"))
    let landTile37 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-37"))
    let landTile36 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-36"))
    let landTile35 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-35"))
    let landTile34 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-34"))
    let landTile31 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-31"))
    let landTile30 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-30"))
    let landTile27 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-27"))
    let landTile26 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-26"))
    let landTile25 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-25"))
    let landTile23 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-23"))
    let landTile22 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-22"))
    let landTile21 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-21"))
    let landTile20 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-20"))
    let landTile18 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-18"))
    let landTile17 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-17"))
    let landTile13 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-13"))
    let landTile12 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-12"))
    let landTile11 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-11"))
    let landTile3 = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-3"))
    
    let landTileGroupRule = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [landTile64, landTile63, landTile56, landTile55, landTile54, landTile53, landTile48, landTile47, landTile46, landTile45, landTile44, landTile43, landTile40, landTile39, landTile37, landTile36, landTile35, landTile34, landTile31, landTile30, landTile27, landTile26, landTile25, landTile23, landTile22, landTile21, landTile20, landTile18, landTile17, landTile13, landTile12, landTile11, landTile3])
    
    let landTileGroup = SKTileGroup(rules: [landTileGroupRule])
    
    let tileSet = SKTileSet(tileGroups: [waterTileGroup, landTileGroup], tileSetType: .grid)
    
    tileMap = SKTileMapNode(tileSet: tileSet, columns: 8, rows: 8, tileSize: waterTile.size)
    tileMap.fill(with: waterTileGroup)
    
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile64, forColumn: 7, row: 0)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile63, forColumn: 6, row: 0)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile56, forColumn: 7, row: 1)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile55, forColumn: 6, row: 1)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile54, forColumn: 5, row: 1)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile53, forColumn: 4, row: 1)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile48, forColumn: 7, row: 2)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile47, forColumn: 6, row: 2)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile46, forColumn: 5, row: 2)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile45, forColumn: 4, row: 2)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile44, forColumn: 3, row: 2)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile43, forColumn: 2, row: 2)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile40, forColumn: 7, row: 3)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile39, forColumn: 6, row: 3)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile37, forColumn: 4, row: 3)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile36, forColumn: 3, row: 3)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile35, forColumn: 2, row: 3)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile34, forColumn: 1, row: 3)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile31, forColumn: 6, row: 4)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile30, forColumn: 5, row: 4)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile27, forColumn: 2, row: 4)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile26, forColumn: 1, row: 4)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile25, forColumn: 0, row: 4)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile23, forColumn: 6, row: 5)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile22, forColumn: 5, row: 5)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile21, forColumn: 4, row: 5)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile20, forColumn: 3, row: 5)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile18, forColumn: 1, row: 5)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile17, forColumn: 0, row: 5)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile13, forColumn: 4, row: 6)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile12, forColumn: 3, row: 6)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile11, forColumn: 2, row: 6)
    tileMap.setTileGroup(landTileGroup, andTileDefinition: landTile3, forColumn: 2, row: 7)
    
    self.addChild(tileMap)
  }
  
  func createMap() {
//    self.addChild(map)
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
    
    tileMap.position.x = player.x
    tileMap.position.y = player.y
    
    player.plane.zRotation = CGFloat(player.angle * M_PI / 180)
  }
}
