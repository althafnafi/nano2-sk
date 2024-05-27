//
//  ViewController.swift
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 15/05/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    // SceneKit stuff
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var upperControlsView: UIView!
    
    var selectedNode: SCNNode?
    
    var isRotating = false
    
    // Shaders stuff
    var shaders = [SCNShaderModifierEntryPoint:String]()
    
    var shaderMod : String = ""
    
    // Coaching Overlay
    let coachingOverlay = ARCoachingOverlayView()
    
    // Arrow Sequence Tracking
    let arrowIds = ["DOWN_ARROW", "UP_ARROW", "RIGHT_ARROW", "LEFT_ARROW"]
    var currentSequenceIndex = 0
    var missionDoneCount = 0
    var arrowMissionDone = false
    let numberOfMission = 1
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    var gameModel: GameModel = GameModel()
    
    let updateQueue = DispatchQueue(label: "altnafi.nano2-sk.sceneKitQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.rendersMotionBlur = true
        sceneView.automaticallyUpdatesLighting = true
        
        // From coaching overlay extension
        //        setupCoachingOverlay()
        
        // Setup new game session
        gameModel.newGameSession()
        
        print(gameModel.gameCode)
        print("===")
        
        if let finalSequence = gameModel.finalSequence {
            for item in finalSequence {
                print(item)
            }
        }
        
        // Load scenes
        let scene = SCNScene()
        let arrowPcbScene = SCNScene(named: "art.scnassets/pcb_1.3.scn")!
        
        // Add model
        guard let arrowPcbRaw = arrowPcbScene.rootNode.childNode(withName: "pcb_1", recursively: true) else {
            sceneView.scene = scene
            print("childNode not found!")
            return
        }
        
        // Add shaders to models
        let arrowPcbNode = addCelShaders(node: arrowPcbRaw)
        
        // SCNText
        guard let codeTextNode = arrowPcbNode.childNode(withName: "CODE_TEXT", recursively: true) else {
            sceneView.scene = scene
            print("codeText not found!")
            return
        }
        
        
        let codeText = SCNText(string: gameModel.gameCode, extrusionDepth: 2.0)
        guard let pixemonFont = UIFont(name: "PixemonTrial-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                       Failed to load pixemon font.
                       Make sure filename is correct.
                       """)
        }
        
        codeText.font = pixemonFont
        
        // Add text to PCB
        codeTextNode.geometry = codeText
        codeTextNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        codeTextNode.scale = SCNVector3(5, 5, 5)
        
        let greekLeft = SCNText(string: "ξ", extrusionDepth: 2.0)
        guard let basis33Font = UIFont(name: "basis33", size: UIFont.labelFontSize) else {
            fatalError("""
                       Failed to load basis33 font.
                       Make sure filename is correct.
                       """)
        }
        
        greekLeft.font = basis33Font
        guard let greekLeftNode = arrowPcbNode.childNode(withName: "GREEK_SYMBOL_LEFT", recursively: true) else {
            sceneView.scene = scene
            print("greekLeftNode not found!")
            return
        }
        
        // Add text to PCB
        greekLeftNode.geometry = greekLeft
        greekLeftNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        greekLeftNode.scale = SCNVector3(10, 10, 5)
        
        // Change position and scale of model
        arrowPcbNode.scale = SCNVector3(0.15, 0.15, 0.15)
        arrowPcbNode.position = SCNVector3(0, -0.5, -2)
        // Add node to root node
        scene.rootNode.addChildNode(arrowPcbNode)
        print("pcb added!")
        selectedNode = arrowPcbNode
        
        // Lighting
        let light:SCNLight = SCNLight()
        light.type = .omni
        light.intensity = 20
        
        let lightNode:SCNNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3.init(-1, 2, 1)
        scene.rootNode.addChildNode(lightNode)
        
        let leftLedLight: SCNLight = SCNLight()
        leftLedLight.type = .directional
        leftLedLight.intensity = 30
        
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.debugOptions =  [.showFeaturePoints, ]
        sceneView.autoenablesDefaultLighting = true
        
        // Add gesture recognizers
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 1.0
        sceneView.addGestureRecognizer(longPressRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sceneView.addGestureRecognizer(panRecognizer)
        
        
    }
    
    func handleTappedNode(tappedNode: SCNNode?) {
        guard let tappedNodeName = tappedNode?.name else { return }
        if !arrowMissionDone {
            checkArrowMission(tappedNodeName: tappedNodeName)
        }
    }
    
    // MARK: -
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal]
        configuration.isLightEstimationEnabled = true
        
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        /// Reset and start `session`
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    //    func renderer(_ renderer: )
    //
    //    func session(_ session: ARSession, didFailWithError error: Error) {
    //        // Present an error message to the user
    //
    //    }
    //
    //    func sessionWasInterrupted(_ session: ARSession) {
    //        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    //
    //    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    // MARK: - Missions
    func showMissionFailed() {
        print("Mission failed!")
    }
    
    func showMissionCompleted() {
        print("Mission completed!")
    }
}
