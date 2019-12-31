//
//  ViewController.swift
//  ARRuler
//
//  Created by Glad Poenaru on 2019-12-31.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched the screen")
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
        }
    
    func addDot(at hitResult : ARHitTestResult) {
        let sphere = SCNSphere(radius: 0.005)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIColor.red
        sphere.materials = [sphereMaterial]
        
        let dot = SCNNode()
        dot.geometry = sphere
        dot.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(dot)
        
        dotNodes.append(dot)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
        
        let a = start.position.x - end.position.x
        let b = start.position.y - end.position.y
        let c = start.position.z - end.position.z
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        print(distance)
        
        updateText(text: "\(distance)", atPosition: end.position)
        
        // the distance between the points is
        // d = √[(x1-x2)²+(y1-y2)²+(z1-z2)²]
    }
     
    func updateText(text : String, atPosition : SCNVector3) {
        let textGeometry = SCNText(string: text, extrusionDepth: 0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let textNode = SCNNode()
        textNode.geometry = textGeometry
        textNode.position = SCNVector3(atPosition.x, atPosition.y, atPosition.z-0.3)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
     
}

