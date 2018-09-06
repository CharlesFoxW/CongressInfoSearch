//
//  BillDetailsView.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/26/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import SwiftyJSON

class BillDetailsView: UIViewController {
    
    var thisJson: JSON = []
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = thisJson["official_title"].stringValue
        self.tableView.registerCellNib(DetailsTableViewCell.self)
        self.tableView.registerCellNib(DetailsTableViewLinkCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Bill Details"
        self.navigationItem.rightBarButtonItem = nil
        if StoredFavorites.favBillList.contains(thisJson) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "StarFilled"), style: .plain, target: self, action: #selector(toggleFavStar(sender:)))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "StarEmpty"), style: .plain, target: self, action: #selector(toggleFavStar(sender:)))
        }
    }
    
    @objc private func toggleFavStar(sender: UIBarButtonItem) {
        if StoredFavorites.favBillList.contains(thisJson) {
            let currIndex = StoredFavorites.favBillList.index(of: thisJson)
            StoredFavorites.favBillList.remove(at: currIndex!)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "StarEmpty")
        } else {
            StoredFavorites.favBillList.append(thisJson)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "StarFilled")
        }
    }
    
}

extension BillDetailsView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailsTableViewCell.height()
    }
    
}

extension BillDetailsView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            let data = DetailsTableViewCellData(labelText: "Bill ID", contentText: thisJson["bill_id"].stringValue)
            cell.setData(data)
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            let data = DetailsTableViewCellData(labelText: "Bill Type", contentText: thisJson["bill_type"].stringValue.uppercased())
            cell.setData(data)
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            let data = DetailsTableViewCellData(labelText: "Sponsor", contentText: thisJson["sponsor"]["first_name"].stringValue + " " + thisJson["sponsor"]["last_name"].stringValue)
            cell.setData(data)
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData
            if thisJson["last_action_at"].stringValue != "" {
                let timeString = thisJson["last_action_at"].stringValue
                let indexToEnd = timeString.index(timeString.startIndex, offsetBy: 10)
                let dateString = timeString.substring(to: indexToEnd)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd MMM yyyy"
                data = DetailsTableViewCellData(labelText: "Last Action", contentText: dateFormatter.string(from: dateObj!))
            } else {
                data = DetailsTableViewCellData(labelText: "Last Action", contentText: "N.A.")
            }
            cell.setData(data)
            return cell
        case 4:
            if thisJson["last_version"]["urls"]["pdf"].stringValue != "" {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewLinkCell.identifier) as! DetailsTableViewLinkCell
                var data: DetailsTableViewLinkCellData
                data = DetailsTableViewLinkCellData(labelText: "PDF", contentText: thisJson["last_version"]["urls"]["pdf"].stringValue)
                cell.setData(data)
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
                let data = DetailsTableViewCellData(labelText: "PDF", contentText: "N.A.")
                cell.setData(data)
                return cell
            }
            
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData
            if thisJson["chamber"].stringValue == "house" {
                data = DetailsTableViewCellData(labelText: "Chamber", contentText: "House")
            } else if thisJson["chamber"].stringValue == "senate" {
                data = DetailsTableViewCellData(labelText: "Chamber", contentText: "Senate")
            } else {
                data = DetailsTableViewCellData(labelText: "Chamber", contentText: "N.A.")
            }
            cell.setData(data)
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData
            if thisJson["last_vote_at"].stringValue != "" {
                let timeString = thisJson["last_vote_at"].stringValue
                let indexToEnd = timeString.index(timeString.startIndex, offsetBy: 10)
                let dateString = timeString.substring(to: indexToEnd)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd MMM yyyy"
                data = DetailsTableViewCellData(labelText: "Last Vote", contentText: dateFormatter.string(from: dateObj!))
            } else {
                data = DetailsTableViewCellData(labelText: "Last Vote", contentText: "N.A.")
            }
            cell.setData(data)
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData
            if thisJson["history"]["active"].boolValue == false {
                data = DetailsTableViewCellData(labelText: "Status", contentText: "New")
            } else {
                data = DetailsTableViewCellData(labelText: "Status", contentText: "Active")
            }
            cell.setData(data)
            return cell
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            let data = DetailsTableViewCellData(labelText: "", contentText: "")
            cell.setData(data)
            return cell
        }
        
    }
}
