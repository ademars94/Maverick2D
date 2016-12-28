//
//  GameScene.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/19/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit
import GameplayKit
import SocketIO

class GameScene: SKScene {
  
  var tileMap = SKTileMapNode()
  
  var player = Player(x: 0, y: 0, angle: 0, speed: 7, plane: Plane(type: "spitfire"))
  var lastUpdatedTime: TimeInterval = 0.0
  
  var isTurningRight = false
  var isTurningLeft = false
  var turningAbility: Double = 2
  
  lazy var analogStick: AnalogStick = {
    let y = (self.size.height / -2) + 144
    let stick = AnalogStick(position: CGPoint(x: 0, y: y), radius: 96)
    stick.name = "analogStick"
    return stick
  }()
  
  let socket = SocketIOClient(socketURL: URL(string: "http://172.24.32.15:3000")!, config: [])
  
  override func didMove(to view: SKView) {
    createTileMap()
    createCamera()
    createPlane()
    createAnalogStick()
    socket.connect()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let projectile = Projectile(type: "bullet", angle: player.angle, x: player.x, y: player.y)
    projectile.position.x = player.x
    projectile.position.y = player.y
    self.addChild(projectile)
    
    let client = ["name": "iOS", "plane": "0", "id": socket.sid!]
    print(JSONSerialization.isValidJSONObject(client))
    
    socket.emit("spawn", client)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      print(touch.force)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  
  }
  
  override func update(_ currentTime: TimeInterval) {
    if lastUpdatedTime == 0.0 {
      lastUpdatedTime = currentTime
    }
    
    var accumulatedFrames = round((currentTime - lastUpdatedTime) * 60)
    
    lastUpdatedTime = currentTime
    
    while accumulatedFrames > 0 {
      updateWorld()
      accumulatedFrames -= 1
    }
  }
  
  func updateWorld() {
    movePlane()
    moveProjectiles()
  }
  
  func moveProjectiles() {
    enumerateChildNodes(withName: "projectile", using: { (node, error) in
      if let projectile = node as? Projectile {
        let dx = projectile.position.x - CGFloat(projectile.velocity * sin(M_PI / 180 * projectile.angle))
        let dy = projectile.position.y + CGFloat(projectile.velocity * cos(M_PI / 180 * projectile.angle))
        
        if dx < 2048 && dx > -2048 {
          projectile.position.x = dx
        } else {
          projectile.removeFromParent()
        }
        
        if dy < 2048 && dy > -2048 {
          projectile.position.y = dy
        } else {
          projectile.removeFromParent()
        }
        
        projectile.zRotation = CGFloat(projectile.angle * M_PI / 180)
      }
    })
  }
  
  func movePlane() {
    if analogStick.stick.position.y > 0 {
      player.speed = 7 + 0.03 * Double(analogStick.stick.position.y)
    } else {
      player.speed = 7
    }
    
    let dx = player.x - CGFloat(player.speed * sin(M_PI / 180 * player.angle))
    let dy = player.y + CGFloat(player.speed * cos(M_PI / 180 * player.angle))
    
    if dx < 2048 && dx > -2048 {
      player.x = dx
    }
    
    if dy < 2048 && dy > -2048 {
      player.y = dy
    }
    
    if analogStick.isTurningLeft {
      player.angle += -0.02 * Double(analogStick.stick.position.x)
    } else if analogStick.isTurningRight {
      player.angle -= 0.02 * Double(analogStick.stick.position.x)
    }
    
    camera?.position.x = player.x
    camera?.position.y = player.y
    
    camera?.zRotation = CGFloat(player.angle * M_PI / 180)
  }
  
  func createCamera() {
    let cam = SKCameraNode()
    self.camera = cam
    self.addChild(cam)
  }
  
  func createAnalogStick() {
    self.camera?.addChild(analogStick)
  }
  
  func createPlane() {
    player.plane.position = CGPoint(x: 0, y: 0)
    self.camera?.addChild(player.plane)
  }
  
  func createTileMap() {
    let waterTile = SKTileDefinition(texture: SKTexture(imageNamed: "map-tile-1"))
    let waterTileGroup = SKTileGroup(tileDefinition: waterTile)
    
    var tileDefinitions = [SKTileDefinition]()
    
    var i = 34
    while i >= 0 {
      tileDefinitions.append(SKTileDefinition(texture: SKTexture(imageNamed: "land-tile-\(i)")))
      i -= 1
    }
    
    let landTileGroupRule = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: tileDefinitions)
    let landTileGroup = SKTileGroup(rules: [landTileGroupRule])
    
    let tileSet = SKTileSet(tileGroups: [waterTileGroup, landTileGroup], tileSetType: .grid)
    
    tileMap = SKTileMapNode(tileSet: tileSet, columns: 8, rows: 8, tileSize: waterTile.size)
    tileMap.fill(with: waterTileGroup)
    
    let columns = [7, 6, 7, 6, 5, 4, 7, 6, 5, 4, 3, 2, 7, 6, 5, 4, 3, 2, 1, 6, 5, 2, 1, 0, 6, 5, 4, 3, 1, 0, 4, 3, 2, 1, 2]
    let rows    = [0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7]
    
    for (index, tile) in tileDefinitions.enumerated() {
      tileMap.setTileGroup(landTileGroup, andTileDefinition: tile, forColumn: columns[index], row: rows[index])
    }
    
    self.addChild(tileMap)
  }
}
