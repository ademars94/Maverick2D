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

class GameScene: SKScene, GCDAsyncUdpSocketDelegate {
  
  var tileMap = SKTileMapNode()
  
  var player = Player(name: "iOS", id: "", x: 0, y: 0, angle: 0, speed: 7, plane: Plane(type: "spitfire"))
  var lastUpdatedTime: TimeInterval = 0.0
  
  var isTurningRight = false
  var isTurningLeft = false
  var turningAbility: Double = 2
  var tag = 1
  
  var hostUrl = "172.24.32.15"
  var hostPort: UInt16 = 3000
  var socket: GCDAsyncUdpSocket?
  
  lazy var analogStick: AnalogStick = {
    let y = (self.size.height / -2) + 144
    let stick = AnalogStick(position: CGPoint(x: 0, y: y), radius: 96)
    stick.name = "analogStick"
    return stick
  }()
  
  override func didMove(to view: SKView) {
    backgroundColor = UIColor(red:0.72, green:0.86, blue:1.0, alpha:1.0)
    createTileMap()
    createCamera()
    createPlane()
    createAnalogStick()
    createSocket()
    createSocketHandlers()
  }
  
  func createSocket() {
    self.socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
    guard let socket = self.socket else {
      return
    }
    
    try? socket.beginReceiving()
    
  }
  
  func sendAction() {
    guard let socket = self.socket else {
      print("Could not unwrap socket.")
      return
    }
    
    let timestamp = Date().millisecondsSince1970()
    let dict: [String: Any] = ["timestamp": timestamp]
    
    if JSONSerialization.isValidJSONObject(dict) {
      guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
        return
      }
      
      socket.send(data, toHost: hostUrl, port: hostPort, withTimeout: 10, tag: self.tag)
      self.tag += 1
    } else {
      print("Could not create valid JSON object.")
    }
  }
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
    print("Sending message \(tag) to \(hostUrl) on port \(hostPort).")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let projectile = Projectile(type: "bullet", angle: player.angle, x: player.x, y: player.y)
    projectile.position.x = player.x
    projectile.position.y = player.y
    self.addChild(projectile)
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
    sendAction()
  }
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
    print("Got the data!!!")
  }
  
  func createSocketHandlers() {
    
//    socket.on("connect") { _ in
//      self.player.id = self.socket.sid ?? ""
//      let client : [String: Any] = ["name": self.player.name, "id": self.player.id, "x": self.player.x, "y": self.player.y, "angle": self.player.angle, "speed": self.player.speed, "plane": "0"]
//      self.socket.emit("spawn", client)
//    }
//    
//    socket.on("correction") { data in
//      if let player = data.0[0] as? [String: Any] {
//        self.correctPlayerPosition(player: player)
//      }
//    }
//    
//    socket.on("updateGameState") { data in
//      if let players = data.0[0] as? [[String: Any]] {
//        for player in players {
//          if let id = player["id"] as? String {
//            if id == self.player.id {
////              self.correctPlayerPosition(player: player)
//            }
//          }
//        }
//      }
//    }
  }
  
  func correctPlayerPosition(player: [String: Any]) {
    if let x = player["x"] as? CGFloat, let y = player["y"] as? CGFloat, let angle = player["angle"] as? Double {
      let dx = self.player.x - x
      let dy = self.player.y - y
      let da = self.player.angle - angle
      
      print("------------ Begin -------------")
      
      if abs(dx) > 100 {
        print("Delta X is \(dx). Correcting...")
        self.player.x = x
      }
      
      if abs(dy) > 100 {
        print("Delta Y is \(dy). Correcting...")
        self.player.y = y
      }
      
      if abs(da) > 100 {
        self.player.angle = angle
      }
      
      print("------------- End --------------")
    }
  }
  
  func movePlane() {
//    if analogStick.stick.position.y > 0 {
//      player.speed = 7 + 0.03 * Double(analogStick.stick.position.y)
//    } else {
//      player.speed = 7
//    }
    
    let dx = self.player.x - CGFloat(self.player.speed * sin(M_PI / 180 * self.player.angle))
    let dy = self.player.y + CGFloat(self.player.speed * cos(M_PI / 180 * self.player.angle))
    
    if dx < 2048 && dx > -2048 {
      self.player.x = dx
    }
    
    if dy < 2048 && dy > -2048 {
      self.player.y = dy
    }
    
    if self.analogStick.isTurningLeft {
      self.player.angle += -0.02 * Double(analogStick.stick.position.x)
      let client : [String: Any] = ["id": self.player.id, "angle": self.player.angle]
//      socket.emit("changeAngle", client)
    } else if self.analogStick.isTurningRight {
      self.player.angle -= 0.02 * Double(analogStick.stick.position.x)
      let client : [String: Any] = ["id": self.player.id, "angle": self.player.angle]
//      socket.emit("changeAngle", client)
    }
    
    camera?.position.x = player.x
    camera?.position.y = player.y
    
    camera?.zRotation = CGFloat(player.angle * M_PI / 180)
    
    let client : [String: Any] = ["name": self.player.name, "id": self.player.id, "x": self.player.x, "y": self.player.y, "angle": self.player.angle, "speed": self.player.speed]
//    self.socket.emit("planeMove", client)
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
  
//  func moveEnemy(id: String, x: CGFloat, y: CGFloat, angle: Double) {
//    enumerateChildNodes(withName: "enemy") { enemyNode, error in
//      if let enemy = enemyNode as? Enemy {
//        if enemy.id == id {
//          enemy.position.x = x
//          enemy.position.y = y
//          enemy.zRotation = CGFloat(angle * M_PI / 180)
//        }
//      }
//    }
//  }
  
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
