//
//  MainMenu.swift
//  SpriteKitIntro
//
//  Created by Shawn Looker on 6/11/16.
//  Copyright © 2016 Shawn Looker. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFill
        let transition:SKTransition = SKTransition.flipVerticalWithDuration(1.0)
        
        self.view?.presentScene(game, transition: transition)
    }
}