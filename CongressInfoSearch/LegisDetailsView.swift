//
//  LegisDetailsView.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/25/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import SwiftyJSON

class LegisDetailsView: UIViewController {
    
    var thisJson: JSON = []
    @IBOutlet weak var thePhotoView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePhotoView.downloadedFrom(link: "https://theunitedstates.io/images/congress/original/"
            + thisJson["bioguide_id"].stringValue + ".jpg")
        self.tableView.registerCellNib(DetailsTableViewCell.self)
        self.tableView.registerCellNib(DetailsTableViewLinkCell.self)
        //self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Legislator Details"
        self.navigationItem.rightBarButtonItem = nil
        if StoredFavorites.favLegisList.contains(thisJson) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "StarFilled"), style: .plain, target: self, action: #selector(toggleFavStar(sender:)))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "StarEmpty"), style: .plain, target: self, action: #selector(toggleFavStar(sender:)))
        }
    }
    
    @objc private func toggleFavStar(sender: UIBarButtonItem) {
        if StoredFavorites.favLegisList.contains(thisJson) {
            let currIndex = StoredFavorites.favLegisList.index(of: thisJson)
            StoredFavorites.favLegisList.remove(at: currIndex!)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "StarEmpty")
        } else {
            StoredFavorites.favLegisList.append(thisJson)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "StarFilled")
        }
    }
    
}

extension LegisDetailsView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailsTableViewCell.height()
    }
    
}

extension LegisDetailsView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.row) {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            let data = DetailsTableViewCellData(labelText: "First Name", contentText: thisJson["first_name"].stringValue)
            cell.setData(data)
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            let data = DetailsTableViewCellData(labelText: "Last Name", contentText: thisJson["last_name"].stringValue)
            cell.setData(data)
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            let data = DetailsTableViewCellData(labelText: "State", contentText: thisJson["state_name"].stringValue)
            cell.setData(data)
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData? = nil
            if thisJson["birthday"].stringValue != "" {
                let timeString = thisJson["birthday"].stringValue
                let indexToEnd = timeString.index(timeString.startIndex, offsetBy: 10)
                let dateString = timeString.substring(to: indexToEnd)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd MMM yyyy"
                data = DetailsTableViewCellData(labelText: "Birth Date", contentText: dateFormatter.string(from: dateObj!))
            } else {
                data = DetailsTableViewCellData(labelText: "Birth Date", contentText: "N.A.")
            }
            cell.setData(data)
            return cell
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData? = nil
            if thisJson["gender"].stringValue == "M" {
                data = DetailsTableViewCellData(labelText: "Gender", contentText: "Male")
            } else {
                data = DetailsTableViewCellData(labelText: "Gender", contentText: "Female")
            }
            cell.setData(data)
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData? = nil
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
            var data: DetailsTableViewCellData? = nil
            if thisJson["fax"].stringValue != "" {
                data = DetailsTableViewCellData(labelText: "Fax No.", contentText: thisJson["fax"].stringValue)
            } else {
                data = DetailsTableViewCellData(labelText: "Fax No.", contentText: "N.A.")
            }
            cell.setData(data)
            return cell
        case 7:
            if thisJson["twitter_id"].stringValue != "" {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewLinkCell.identifier) as! DetailsTableViewLinkCell
                let data = DetailsTableViewLinkCellData(labelText: "Twitter", contentText: thisJson["twitter_id"].stringValue)
                cell.setData(data)
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
                let data = DetailsTableViewCellData(labelText: "Twitter", contentText: "N.A.")
                cell.setData(data)
                return cell
            }
        case 8:
            if thisJson["website"].stringValue != "" {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewLinkCell.identifier) as! DetailsTableViewLinkCell
                let data = DetailsTableViewLinkCellData(labelText: "Website", contentText: thisJson["website"].stringValue)
                cell.setData(data)
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
                let data = DetailsTableViewCellData(labelText: "Website", contentText: "N.A.")
                cell.setData(data)
                return cell
            }
        case 9:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData? = nil
            if thisJson["office"].stringValue != "" {
                data = DetailsTableViewCellData(labelText: "Office", contentText: thisJson["office"].stringValue)
            } else {
                data = DetailsTableViewCellData(labelText: "Office", contentText: "N.A.")
            }
            cell.setData(data)
            return cell
        case 10:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
            var data: DetailsTableViewCellData? = nil
            if thisJson["term_end"].stringValue != "" {
                let timeString = thisJson["term_end"].stringValue
                let indexToEnd = timeString.index(timeString.startIndex, offsetBy: 10)
                let dateString = timeString.substring(to: indexToEnd)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd MMM yyyy"
                data = DetailsTableViewCellData(labelText: "Term Ends On", contentText: dateFormatter.string(from: dateObj!))
            } else {
                data = DetailsTableViewCellData(labelText: "Term Ends On", contentText: "N.A.")
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
