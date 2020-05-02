//
//  ViewController.swift
//  ARDice
//
//  Created by Malik Adebiyi on 2020-04-28.
//  Copyright © 2020 dot.sandbox. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //create cube
        //        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        //        let sphere = SCNSphere(radius: 0.2)
        //
        //        //create material
        //        let material = SCNMaterial()
        //
        //        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
        //
        //        // add material to cube
        //        sphere.materials = [material]
        //
        //        // create node, a position in 3D space
        //        let node = SCNNode()
        //
        //        node.position = SCNVector3(0, 0.1, -0.5)
        //
        //        node.geometry = sphere
        //
        //
        //
        //        //add node to scene
        //        sceneView.scene.rootNode.addChildNode(node)
        //
        // add light to scene
        
        sceneView.autoenablesDefaultLighting = true
        
        
        
        // Create a new scene
        //        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        //
        //        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
        //
        //        diceNode.position = SCNVector3(0, 0, -0.1)
        //
        //        sceneView.scene.rootNode.addChildNode(diceNode)
        //        // Set the scene to the view
        ////        sceneView.scene = scene
        //            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // detect horizontal plane / surface
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // method gets called when a touch is detected
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                
                //Create a new Scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                if let diceNode = diceScene.rootNode.childNode(withName :"Dice", recursively: true) {
                    diceNode.position = SCNVector3 (
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z
                    )
                    
                    diceArray.append(diceNode)
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    roll(dice: diceNode)

                }
                
            }
        }
        
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
                    
                    let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
                    
                    dice.runAction(
                        SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5)
                    )
    }
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty {
            // loop through all the dice in dice array
            for dice in diceArray {
                // remove from parent node
                dice.removeFromParentNode()
                
            }
        }
    }
    
    // tell the scene that horizontal plaen has been detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // create plane anchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // create plane node
            let planeNode = SCNNode()
            
            // set plane node position
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            // transform plane node
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            // set material to image
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
        } else {
            return
        }
    }
    
    
}
