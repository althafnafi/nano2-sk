//
//  +GameLogic.swift
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 27/05/24.
//

import Foundation
import ARKit

extension ViewController {
    
    func stringToArrowKey(arrowName: String) -> ArrowKey? {
      switch arrowName {
      case "up", "UP_ARROW":
        return .up
      case "down", "DOWN_ARROW":
        return .down
      case "left", "LEFT_ARROW":
        return .left
      case "right", "RIGHT_ARROW":
        return .right
      default:
        return nil
      }
    }

    
    func checkArrowMission(tappedNodeName: String) {
        if arrowIds.contains(tappedNodeName) {
          // Check if tapped node matches the expected sequence element
            let tappedNode = stringToArrowKey(arrowName: tappedNodeName)
            if let finalSequence = gameModel.finalSequence {
                if tappedNode == finalSequence[currentSequenceIndex] {
                currentSequenceIndex += 1
                if currentSequenceIndex == finalSequence.count {
                  // Sequence completed successfully
                  missionDoneCount += 1
                  print("Arrow mission completed! Sequence count: \(missionDoneCount)")
                    currentSequenceIndex = 0
                  // Show success message (add your implementation here)
                    arrowMissionDone = true
                }
              } else {
                // Sequence broken, reset
                print("Sequence broken!")
                currentSequenceIndex = 0
                
                // Show "PCB Broke!" text (add your implementation here)
              }
            } else {
              // Ignore taps on non-arrow nodes
              print("Tapped non-arrow node: \(tappedNodeName)")
            }
            } else {
                print("Error checking arrow mission")
                return
            }
    }
}
