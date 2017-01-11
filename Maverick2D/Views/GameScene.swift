//
//  GameScene.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/19/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit
import GameplayKit
import CocoaAsyncSocket

class GameScene: SKScene, SocketControllerDelegate, AnalogStickDelegate {
  
  var tileMap = SKTileMapNode()
  
  var player = Player(name: "iOS", id: 0, x: 0, y: 0, angle: 0, speed: 7, plane: Plane(type: "mustang"))
  var lastUpdatedTime: TimeInterval = 0.0
  var enemies = [Player]()
  
  lazy var socketController: SocketController = {
    let controller = SocketController(delegate: self)
    return controller
  }()
  
  lazy var analogStick: AnalogStick = {
    let y = (self.size.height / -2) + 144
    let stick = AnalogStick(position: CGPoint(x: 0, y: y), radius: 64, delegate: self)
    stick.name = "analogStick"
    return stick
  }()
  
  override func didMove(to view: SKView) {
    backgroundColor = UIColor(red:0.72, green:0.86, blue:1.0, alpha:1.0)
    
    NotificationCenter.default.addObserver(self, selector: #selector(killPlayer), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(killPlayer), name: Notification.Name.UIApplicationWillTerminate, object: nil)
    
    createTileMap()
    createCamera()
    createPlane()
    createAnalogStick()
    setupSocket()
  }
  
  func setupSocket() {
    self.socketController.createSocket { _ in
      self.sendJoinRequest()
    }
  }
  
  func sendJoinRequest() {
    self.player.id = socketController.localPort
    
    let playerState: [String: Any] = ["id": self.player.id, "type": "join", "x": self.player.x, "y": self.player.y, "angle": self.player.angle, "speed": self.player.speed]
    
    print("Join Request: \(playerState)")
    socketController.sendSocketMessage(playerState: playerState)
  }
  
  func killPlayer() {
    let playerState: [String: Any] = ["id": socketController.localPort, "type": "die"]
    
    print("Kill Player: \(playerState)")
    socketController.sendSocketMessage(playerState: playerState)
  }
  
  func fire() {
    print("Firing!!!")
  }
  
  func endTracking() {
    let timestamp = Date().millisecondsSince1970()
    let playerState: [String: Any] = ["id": socketController.localPort, "type": "input", "timestamp": timestamp, "turnDelta": self.analogStick.deltaX, "x": self.player.x, "y": self.player.y, "angle": self.player.angle]
    socketController.sendSocketMessage(playerState: playerState)
  }
  
  func sendAction() {
    if self.analogStick.isTracking {
      let timestamp = Date().millisecondsSince1970()
      let playerState: [String: Any] = ["id": socketController.localPort, "type": "input", "timestamp": timestamp, "x": self.player.x, "y": self.player.y, "angle": self.player.angle]
      socketController.sendSocketMessage(playerState: playerState)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let projectile = Projectile(type: "bullet", angle: player.angle, x: player.x, y: player.y)
    projectile.position.x = player.x
    projectile.position.y = player.y
    let fireSound = SKAction.playSoundFileNamed("machine-gun.mp3", waitForCompletion: false)
    self.run(fireSound)
    self.addChild(projectile)
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
    moveEnemies()
    sendAction()
  }
  
  func correctPlayerPosition(player: [String: Any]) {
    print("--- CORRECTION ---")
    print(player)
    if let x = player["x"] as? CGFloat, let y = player["y"] as? CGFloat, let angle = player["angle"] as? Double {
      self.player.x = x
      self.player.y = y
      self.player.angle = angle
    } else {
      print("Could not apply correction.")
    }
  }
  
  func updatePlayerPositions(players: [[String: Any]]) {
    for player in players {
      guard let id = player["id"] as? UInt16, let x = player["x"] as? CGFloat, let y = player["y"] as? CGFloat, let angle = player["angle"] as? Double else {
        print("Couldn't unwrap player.")
        return
      }
      
      // Prevent client from being added into the enemies array
      if id != socketController.localPort {
        let enemy = Player(playerDictionary: player)
        if self.enemies.contains(where: { e in e.id == enemy.id }) {
          print("An enemy is in the game.")
          let point = CGPoint(x: x, y: y)
          correctEnemy(id, to: point, angle: angle)
        } else {
          print("Enemy does not exist.")
          self.enemies.append(enemy)
          self.addChild(enemy.plane)
        }
      }
    }
  }
  
  func movePlane() {
    let dx = self.player.x - CGFloat(self.player.speed * sin(M_PI / 180 * self.player.angle))
    let dy = self.player.y + CGFloat(self.player.speed * cos(M_PI / 180 * self.player.angle))
    
    if dx < 2048 && dx > -2048 {
      self.player.x = dx
    }
    
    if dy < 2048 && dy > -2048 {
      self.player.y = dy
    }
    
    self.player.angle += analogStick.deltaX
    
    camera?.position.x = player.x
    camera?.position.y = player.y
    
    camera?.zRotation = CGFloat(player.angle * M_PI / 180)
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
  
  func moveEnemies() {
    for enemy in enemies {
      print("===== ENEMY =====")
      print("x     : \(enemy.x)")
      print("y     : \(enemy.y)")
      print("angle : \(enemy.angle)")
      print("speed : \(enemy.speed)")
      print("=================")
      
      let dx = enemy.x - CGFloat(enemy.speed * sin(M_PI / 180 * enemy.angle))
      let dy = enemy.y + CGFloat(enemy.speed * cos(M_PI / 180 * enemy.angle))
      
      if dx < 2048 && dx > -2048 {
        enemy.x = dx
      }
      
      if dy < 2048 && dy > -2048 {
        enemy.y = dy
      }
      
      enemy.plane.position.x = enemy.x
      enemy.plane.position.y = enemy.y
      enemy.plane.zRotation = CGFloat(enemy.angle * M_PI / 180)
    }
  }
  
  func correctEnemy(_ id: UInt16, to point: CGPoint, angle: Double) {
    for enemy in enemies {
      if enemy.id != socketController.localPort {
        enemy.movePlane(to: point, angle: angle)
      }
    }
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
