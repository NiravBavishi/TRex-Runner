//
//  GameOverScene.swift
//  TRexRunnerGame
//
//  Created by Abita Shiney on 2019-02-18.
//  Copyright © 2019 Abita Shiney. All rights reserved.
//

import Foundation
import SpriteKit

class FirstScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {

        let background = SKSpriteNode(imageNamed: "background-mainmenu_orig")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        background.size = self.size
        background.zPosition = -1
        addChild(background)

        let backgroundSound = SKAudioNode(fileNamed: "SnowySound.wav")
        self.addChild(backgroundSound)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //when person touches send them back to the 2nd screen or scene

        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode

        //2.configure some animation on screen/scene
        let transitionEffect = SKTransition.flipVertical(withDuration: 2)
        AudioPlayer.shared.setSounds(false)
        //3.Show the scene
        self.view?.presentScene(gameScene,transition: transitionEffect)

    }
}
