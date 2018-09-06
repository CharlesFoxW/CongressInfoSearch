//
//  CommDetailsView.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/26/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommDetailsView: UIViewController {
    
    var thisJson: JSON = []
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = thisJson["name"].stringValue
        self.tableView.registerCellNib(DetailsTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Committee Details"
        self.navigationItem.rightBarButtonItem = nil
        if StoredFavorites.favCommList.contains(thisJson) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "StarFilled"), style: .plain, target: self, action: #selector(toggleFavStar(sender:)))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "StarEmpty"), style: .plain, target: self, action: #selector(toggleFavStar(sender:)))
        }
    }
    
    @objc private func toggleFavStar(sender: UIBarButtonItem) {
        if StoredFavorites.favCommList.contains(thisJson) {
            let currIndex = StoredFavorites.favCommList.index(of: thisJson)
            StoredFavorites.favCommList.remove(at: currIndex!)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "StarEmpty")
        } else {
            StoredFavorites.favCommList.append(thisJson)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "StarFilled")
        }
    }
    
}

extension CommDetailsView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailsTableViewCell.height()
    }
    
}

extension CommDetailsView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
        var data: DetailsTableViewCellData
        switch (indexPath.row) {
        case 0:
            data = DetailsTableViewCellData(labelText: "Committee ID", contentText: thisJson["committee_id"].stringValue)
        case 1:
            if thisJson["parent_committee_id"].stringValue != "" {
                data = DetailsTableViewCellData(labelText: "Parent ID", contentText: thisJson["parent_committee_id"].stringValue)
            } else {
                data = DetailsTableViewCellData(labelText: "Parent ID", contentText: "N.A.")
            }
        case 2:
            if thisJson["chamber"].stringValue == "house" {
                data = DetailsTableViewCellData(labelText: "Chamber", contentText: "House")
            } else if thisJson["chamber"].stringValue == "senate" {
                data = DetailsTableViewCellData(labelText: "Chamber", contentText: "Senate")
            } else {
                data = DetailsTableViewCellData(labelText: "Chamber", contentText: "N.A.")
            }
        case 3:
            if thisJson["office"].stringValue != "" {
                data = DetailsTableViewCellData(labelText: "Office", contentText: thisJson["office"].stringValue)
            } else {
                data = DetailsTableViewCellData(labelText: "Office", contentText: "N.A.")
            }
        case 4:
            if thisJson["phone"].stringValue != "" {
                data = DetailsTableViewCellData(labelText: "Contact", contentText: thisJson["phone"].stringValue)
            } else {
                data = DetailsTableViewCellData(labelText: "Contact", contentText: "N.A.")
            }
        default:
            data = DetailsTableViewCellData(labelText: "", contentText: "")
        }
        cell.setData(data)
        return cell
    }
}
