//
//  LegisStateView.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/23/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SwiftSpinner

class LegisStateView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var json: JSON = []
    var sortedJson: JSON = []
    var selectedJson: JSON = []
    
    var sections : [(index: Int, length :Int, title: String)] = Array()
    var pickerView = UIPickerView()
    var originalView = UIView()
    var isPicking: Bool = false
    var selectedState : String = ""
    
    let states = ["All States",
                  "Alabama",
                  "Alaska",
                  "American Samoa",
                  "Arizona",
                  "Arkansas",
                  "California",
                  "Colorado",
                  "Connecticut",
                  "Delaware",
                  "District of Columbia",
                  "Florida",
                  "Georgia",
                  "Guam",
                  "Hawaii",
                  "Idaho",
                  "Illinois",
                  "Indiana",
                  "Iowa",
                  "Kansas",
                  "Kentucky",
                  "Louisiana",
                  "Maine",
                  "Maryland",
                  "Massachusetts",
                  "Michigan",
                  "Minnesota",
                  "Mississippi",
                  "Missouri",
                  "Montana",
                  "Nebraska",
                  "Nevada",
                  "New Hampshire",
                  "New Jersey",
                  "New Mexico",
                  "New York",
                  "North Carolina",
                  "North Dakota",
                  "Northern Mariana Islands",
                  "Ohio",
                  "Oklahoma",
                  "Oregon",
                  "Pennsylvania",
                  "Puerto Rico",
                  "Rhode Island",
                  "South Carolina",
                  "South Dakota",
                  "Tennessee",
                  "Texas",
                  "Utah",
                  "Vermont",
                  "Virginia",
                  "Virgin Islands",
                  "Washington",
                  "West Virginia",
                  "Wisconsin",
                  "Wyoming",
                  "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Register the cells first:
        self.tableView.registerCellNib(LegisTableViewCell.self)
        
        let parameters: Parameters = ["catagory": "legislators"]
        SwiftSpinner.show("Fetching Data ...")
        Alamofire.request("http://clsfox.us-west-2.elasticbeanstalk.com/index.php",
                          parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Validation Successful")
                self.json = JSON(value)
                let rawArray = self.json["results"].arrayValue
                
                let sortedArray = rawArray.sorted(by: {
                    $0["state_name"].stringValue.characters.first! == $1["state_name"].stringValue.characters.first! ?
                        ($0["last_name"].stringValue == $1["last_name"].stringValue ?
                            $0["first_name"].stringValue < $1["first_name"].stringValue
                            : $0["last_name"].stringValue < $1["last_name"].stringValue)
                        : $0["state_name"].stringValue.characters.first! < $1["state_name"].stringValue.characters.first!
                })
                
                self.sortedJson = JSON(sortedArray)
                self.selectedJson = self.sortedJson
                var index = 0;
                for i in 0...self.selectedJson.count {
                    let stateString = self.selectedJson[i]["state_name"].stringValue
                    let commonPrefix = stateString.commonPrefix(with:self.selectedJson[index]["state_name"].stringValue, options: .caseInsensitive)
                    
                    if (commonPrefix.length == 0 ) {
                        let string = self.selectedJson[index]["state_name"].stringValue.uppercased();
                        let firstCharacter = string == "" ? "#" : string[string.startIndex]
                        let title = "\(firstCharacter)"
                        let newSection = (index: index, length: i - index, title: title)
                        self.sections.append(newSection)
                        index = i;
                    }
                }
                
                // Reload the cells:
                self.tableView.reloadData()
                SwiftSpinner.hide()
            case .failure(let error):
                print("Not Successful")
                print(error)
                SwiftSpinner.hide()
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "Legislators"
        self.parent?.navigationItem.rightBarButtonItem = nil
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(togglePickerView(sender:)))
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func togglePickerView(sender: UIBarButtonItem) {
        
        if isPicking {
            self.parent?.navigationItem.rightBarButtonItem?.title = "Filter"
            self.view = self.originalView
            isPicking = false
        } else {
            self.parent?.navigationItem.rightBarButtonItem?.title = "Cancel"
            self.originalView = self.view
            self.view = pickerView
            isPicking = true
        }
    }
    
}

extension LegisStateView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegisTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LegisDetailsView", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegisDetailsView") as! LegisDetailsView
        subContentsVC.thisJson = self.selectedJson[indexPath.row]
        self.parent?.navigationItem.title = nil
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension LegisStateView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].length
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{ $0.title }
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LegisTableViewCell.identifier) as! LegisTableViewCell
        let data = LegisTableViewCellData(imageUrl: "https://theunitedstates.io/images/congress/original/" + self.selectedJson[sections[indexPath.section].index + indexPath.row]["bioguide_id"].stringValue + ".jpg",
                                          text: self.selectedJson[sections[indexPath.section].index + indexPath.row]["last_name"].stringValue + ", " + self.selectedJson[sections[indexPath.section].index + indexPath.row]["first_name"].stringValue,
                                          detailText: self.selectedJson[sections[indexPath.section].index + indexPath.row]["state_name"].stringValue)
        cell.setData(data)
        return cell
    }
}

extension LegisStateView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if states[row] == "All States" {
            self.selectedState = ""
            self.selectedJson = self.sortedJson
        } else {
            self.selectedState = states[row]
            var selectedArray: [JSON] = []
            let count = self.sortedJson.count
            for i in 0...count {
                if self.sortedJson[i]["state_name"].stringValue == self.selectedState {
                    selectedArray.append(self.sortedJson[i])
                }
            }
            self.selectedJson = JSON(selectedArray)
        }
        // Update the navigation bar
        self.parent?.navigationItem.rightBarButtonItem?.title = "Filter"
        self.view = self.originalView
        isPicking = false
        // Update the sections and reload table
        var index = 0;
        self.sections.removeAll()
        for i in 0...self.selectedJson.count {
            let stateString = self.selectedJson[i]["state_name"].stringValue
            let commonPrefix = stateString.commonPrefix(with:self.selectedJson[index]["state_name"].stringValue, options: .caseInsensitive)
            
            if (commonPrefix.length == 0 ) {
                let string = self.selectedJson[index]["state_name"].stringValue.uppercased();
                let firstCharacter = string == "" ? "#" : string[string.startIndex]
                let title = "\(firstCharacter)"
                let newSection = (index: index, length: i - index, title: title)
                self.sections.append(newSection)
                index = i;
            }
        }
        self.tableView.reloadData()
    }
}

extension LegisStateView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
}








