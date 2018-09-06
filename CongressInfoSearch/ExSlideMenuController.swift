//
//  ExSlideMenuController.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/23/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController : SlideMenuController {
    
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is LegisTabViewController ||
                vc is BillsTabViewController ||
                vc is CommTabViewController ||
                vc is FavTabViewController {
                return true
            }
        }
        return false
    }
    /*
    override func track(_ trackAction: TrackAction) {
        switch trackAction {
        case .leftTapOpen:
            print("TrackAction: left tap open.")
        case .leftTapClose:
            print("TrackAction: left tap close.")
        case .leftFlickOpen:
            print("TrackAction: left flick open.")
        case .leftFlickClose:
            print("TrackAction: left flick close.")
        case .rightTapOpen:
            print("TrackAction: right tap open.")
        case .rightTapClose:
            print("TrackAction: right tap close.")
        case .rightFlickOpen:
            print("TrackAction: right flick open.")
        case .rightFlickClose:
            print("TrackAction: right flick close.")
        }
    }
    */
}
