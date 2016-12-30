//
//  Enemy.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/30/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

//
//  Player.swift
//  Maverick2D
//
//  Created by Alex DeMars on 12/20/16.
//  Copyright © 2016 Alex DeMars. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
  var id: String = ""
  var x: CGFloat = 0
  var y: CGFloat = 0
  var angle: Double = 0
  var velocity: Double = 0
  
  override func setValue(_ value: Any?, forKey key: String) {
    if !self.responds(to: Selector(key)) {
      return
    }
    
    if key == "x" {
//      print("Key is x")
      self.position.x = value as! CGFloat
    }
    
    if key == "y" {
//      print("Key is y")
      self.position.y = value as! CGFloat
    }
    
    super.setValue(value, forKey: key)
  }
  
  init(enemyDictionary: [String: Any]) {
    super.init(texture: SKTexture(imageNamed: "zero"), color: .clear, size: CGSize(width: 128, height: 128))
    setValuesForKeys(enemyDictionary)
    self.name = "enemy"
//    print("-------------------------")
//    print("Id    : \(id)")
//    print("Angle : \(angle)")
//    print("Speed : \(speed)")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

