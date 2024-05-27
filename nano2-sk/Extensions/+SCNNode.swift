//
//  ExtSCNNode.swift
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 22/05/24.
//

import Foundation
import ARKit

extension SCNNode {
    func printChildNodes() {
        self.enumerateChildNodes { (node, _) in
            print("Node: \(String(describing: self.name))")
            print("- \(String(describing: self.name))")
        }
    }
}
