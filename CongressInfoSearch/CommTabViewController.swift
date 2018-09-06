//
//  CommTabViewController.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/23/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit

class CommTabViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addLeftBarButtonWithImage(UIImage(named: "Menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for tabItem in self.tabBar.items! {
            tabItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 18)], for: .normal)
            tabItem.titlePositionAdjustment = UIOffsetMake(0, -12)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
