//
//  GameViewController.swift
//  TRexRunnerGame
//
//  Created by Abita Shiney on 2019-02-08.
//  Copyright © 2019 Abita Shiney. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let scene = FirstScene(size:CGSize(width:2048, height:1536))
        let scene = FirstScene(size:CGSize(width:2048, height:1152))
        //let scene = FirstScene(size:CGSize(width:1334, height:768))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
       // skView.showsPhysics = true
        
      //  backgroundMusic?.play()
        scene.scaleMode = .aspectFit
        
        skView.presentScene(scene)
        
        // playStopBackgroundMusic()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
   
}
