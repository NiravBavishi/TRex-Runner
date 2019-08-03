//
//  OverScene.swift
//  TRexRunnerGame
//
//  Created by Charmi Mehta on 2019-02-22.
//  Copyright  2019 Abita Shiney. All rights reserved.
//

import Foundation
import SpriteKit
class OverScene: SKScene{
init(size: CGSize, won:Bool) {
    super.init(size: size)
    
    // 1
    backgroundColor = SKColor.white
    
    // 2
    let msg = won ? "You Won" : "You Lose"
    
    // 3
    let condition_label = SKLabelNode(fontNamed: "Chalkduster")
    condition_label.text = msg
    condition_label.fontSize = 40
    condition_label.fontColor = SKColor.black
    condition_label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(condition_label)
    
    // 4
    run(SKAction.sequence([
        SKAction.wait(forDuration: 3.0),
        SKAction.run() {
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            let scene = GameScene(size: self.size)
//            scene.scaleMode = self.scaleMode
//            self.view?.presentScene(scene, transition:reveal)
            
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            
            //2.configure some animation on screen/scene
            let transitionEffect = SKTransition.flipVertical(withDuration: 2)
           // AudioPlayer.shared.setSounds(false)
            //3.Show the scene
            self.view?.presentScene(gameScene,transition: transitionEffect)
        }
    ]))
}

// 6
required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}
