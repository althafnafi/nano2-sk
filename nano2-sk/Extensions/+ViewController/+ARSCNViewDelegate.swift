//
//  +ARSCNViewDelegate.swift
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 27/05/24.
//

import Foundation

import ARKit

extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        
        DispatchQueue.main.async { [self] in
            // Update view
            if missionDoneCount >= numberOfMission {
                showMissionCompleted()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {

        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        updateQueue.async {

        }
    }
    
    /// - Tag: ShowVirtualContent
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable, .limited:
            break
        case .normal:
            // Show
            break
        }
    }


    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            print(errorMessage)
//            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Hide content before going into the background.
//        hideVirtualContent()
        print("Interrupted")
    }
//    
//    /// - Tag: HideVirtualContent
//    func hideVirtualContent() {
//        virtualObjectLoader.loadedObjects.forEach { $0.isHidden = true }
//    }

    /*
     Allow the session to attempt to resume after an interruption.
     This process may not succeed, so the app must be prepared
     to reset the session if the relocalizing status continues
     for a long time -- see `escalateFeedback` in `StatusViewController`.
     */
    /// - Tag: Relocalization
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
}

