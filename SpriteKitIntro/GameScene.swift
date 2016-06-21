//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Shawn Looker on 6/6/16.
//  Copyright (c) 2016 Shawn Looker. All rights reserved.
//

import SpriteKit

let wallMask:UInt32 = 0x1 // 1
let ballMask:UInt32 = 0x1 << 1 // 2
let pegMask:UInt32 = 0x1 << 2 // 4
let squareMask:UInt32 = 0x1 << 3 // 8
let orangePegMask:UInt32 = 0x1 << 4 // 16

class GameScene: SKScene, SKPhysicsContactDelegate {
    var cannon: SKSpriteNode!
    var background:SKAudioNode!

    var cannon_full: SKSpriteNode!
    var touchLocation: CGPoint = CGPointZero
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        
        cannon_full = self.childNodeWithName("cannon_full") as! SKSpriteNode
        cannon = cannon_full!.childNodeWithName("cannon") as! SKSpriteNode
        background = SKAudioNode(fileNamed: "bg.mp3")
        
        // Add background music to scene
        self.addChild(background)
        
    
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch moves */
        touchLocation = touches.first!.locationInNode(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let ball:SKSpriteNode = SKScene(fileNamed: "Ball")!.childNodeWithName("ball") as! SKSpriteNode
        ball.removeFromParent()
        self.addChild(ball)
        ball.zPosition = 0
        ball.position = cannon_full.position
        print(ball.position)
        
        // Get angle in radians of rotation of cannon
        let angleInRadians = Float(cannon.zRotation)
        let speed = CGFloat(95.0)
        let vx: CGFloat = CGFloat(cosf(angleInRadians)) * speed
        let vy: CGFloat = CGFloat(sinf(angleInRadians)) * speed
        ball.physicsBody?.applyImpulse(CGVectorMake(vx, vy))
        
        ball.physicsBody?.collisionBitMask = wallMask | ballMask | pegMask | orangePegMask
        // Set it to test contacts to everything we collide with PLUS squares
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask | squareMask
        
        // Cannon sound
        self.runAction(SKAction.playSoundFileNamed("cannon.wav", waitForCompletion: true))
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        // Get percentage of user moving finger across the screen
        let percent = touchLocation.x / size.width
        let newAngle = percent * 180 - 180
        
        // Rotate cannon
        cannon.zRotation = CGFloat(newAngle) * CGFloat(M_PI) / 180
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let ball = (contact.bodyA.categoryBitMask == ballMask) ? contact.bodyA : contact.bodyB
        let other = (contact.bodyA.categoryBitMask == ballMask) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == pegMask || other.categoryBitMask == orangePegMask {
            print("hit peg!")
            self.didHitPeg(other)
        } else if other.categoryBitMask == wallMask {
            print("hit wall!")
        } else if other.categoryBitMask == squareMask {
            print("hit square!")
        } else if other.categoryBitMask == ballMask {
            print("hit ball!")
        }
    }
    
    func didHitPeg(peg:SKPhysicsBody) {
        let blue = UIColor(red: 0.16, green: 0.73, blue: 0.78, alpha: 1.0)
        let orange = UIColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 1.0)
        
        let spark:SKEmitterNode = SKEmitterNode(fileNamed: "SparkParticle")!
        spark.position = peg.node!.position
        
        spark.particleColor = (peg.categoryBitMask == orangePegMask) ? orange : blue
        
        
        
        self.addChild(spark)
        
        peg.node?.removeFromParent()
        
        // There's a bit of a stall before the first play, so we need to pre-load from memory.
        self.runAction(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: true))

    }
}
