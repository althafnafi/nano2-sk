//
//  +Gestures.swift
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 27/05/24.
//

import Foundation
import UIKit
import SceneKit


extension ViewController {
    // MARK: Gestures handlers
    @objc func handleTap(rec: UITapGestureRecognizer){
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty {
                let tappedNode = hits.first?.node
                handleTappedNode(tappedNode: tappedNode)
                
                // Check if tapped node is an arrow node
                if isArrowNode(node: tappedNode) {
                  enlargeNode()
                  resetNodeSize()
                } else {
                  print(tappedNode?.name ?? "?") // Handle non-arrow tap (optional)
                }
            }
        }
    }
    
    func isArrowNode(node: SCNNode?) -> Bool {
      guard let nodeName = node?.name else { return false }
      // Replace "arrow_" with your actual arrow node name prefix (if different)
      return nodeName.hasSuffix("_ARROW")
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            enlargeNode()
        case .ended:
            if !isRotating {
                resetNodeSize()
            }
        case .cancelled, .failed:
            resetNodeSize()
        default:
            break
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard isRotating else { return }
        
        let translation = gesture.translation(in: gesture.view!)
        let anglePan = (Float)(translation.x) * (Float)(Double.pi) / 180.0
        
        selectedNode?.eulerAngles.y += anglePan
        
        gesture.setTranslation(CGPoint.zero, in: gesture.view)
        
        if gesture.state == .ended {
            isRotating = false
            resetNodeSize()
        }
        
    }
    
     func enlargeNode() {
         SCNTransaction.begin()
         SCNTransaction.animationDuration = 0.3
         selectedNode?.scale = SCNVector3(0.3, 0.3, 0.3)
         selectedNode?.opacity = 1
         SCNTransaction.completionBlock = {
             self.isRotating = true
         }
         SCNTransaction.commit()
     }
     
     func resetNodeSize() {
         SCNTransaction.begin()
         SCNTransaction.animationDuration = 0.3
         selectedNode?.opacity = 1
         selectedNode?.scale = SCNVector3(0.15, 0.15, 0.15)
         SCNTransaction.commit()
     }
    
}
