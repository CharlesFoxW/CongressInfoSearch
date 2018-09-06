//
//  SideMenuViewController.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/23/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum LeftMenu: Int {
    case legislators = 0
    case bills
    case committees
    case favorites
    case about
}

protocol MenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class SideMenuViewController : UIViewController, MenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["Legislators", "Bills", "Committees", "Favorites", "About"]
    var legisViewController: UIViewController!
    var billsViewController: UIViewController!
    var commViewController: UIViewController!
    var favViewController: UIViewController!
    var aboutViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let billsViewController = storyboard.instantiateViewController(withIdentifier: "BillsTabViewController") as! BillsTabViewController
        self.billsViewController = UINavigationController(rootViewController: billsViewController)
        
        let commViewController = storyboard.instantiateViewController(withIdentifier: "CommTabViewController") as! CommTabViewController
        self.commViewController = UINavigationController(rootViewController: commViewController)
        
        let favViewController = storyboard.instantiateViewController(withIdentifier: "FavTabViewController") as! FavTabViewController
        self.favViewController = UINavigationController(rootViewController: favViewController)
        
        let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .legislators:
            self.slideMenuController()?.changeMainViewController(self.legisViewController, close: true)
        case .bills:
            self.slideMenuController()?.changeMainViewController(self.billsViewController, close: true)
        case .committees:
            self.slideMenuController()?.changeMainViewController(self.commViewController, close: true)
        case .favorites:
            self.slideMenuController()?.changeMainViewController(self.favViewController, close: true)
        case .about:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
        }
    }
}

extension SideMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legislators, .bills, .committees, .favorites, .about:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
}

extension SideMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legislators, .bills, .committees, .favorites, .about:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}

