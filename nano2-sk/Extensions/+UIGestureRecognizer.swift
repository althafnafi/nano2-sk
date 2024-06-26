//
//  Ext_UIGestureRecognizer.swift
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 22/05/24.
//

import UIKit

extension UIGestureRecognizer {
    func getCenter(in view: UIView) -> CGPoint? {
        guard numberOfTouches > 0 else { return nil }
        
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)

        let touchBounds = (1..<numberOfTouches).reduce(first) { touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }

        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
}
