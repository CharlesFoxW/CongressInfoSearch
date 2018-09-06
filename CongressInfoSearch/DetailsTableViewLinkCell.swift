//
//  DetailsTableViewLinkCell.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/27/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import Foundation
import UIKit

struct DetailsTableViewLinkCellData {
    
    init(labelText: String, contentText: String) {
        self.labelText = labelText
        self.contentText = contentText
    }
    
    var labelText: String
    var contentText: String
}

class DetailsTableViewLinkCell: BaseTableViewCell {
    
    var contentText: String = ""
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var linkButtonView: UIButton!
    @IBAction func linkButton(_ sender: Any) {
        if self.labelText.text == "Twitter" {
            openUrl(url: "http://twitter.com/" + self.contentText)
        } else if self.labelText.text == "Website" || self.labelText.text == "PDF" {
            openUrl(url: self.contentText)
        }
    }
    
    override class func height() -> CGFloat {
        return 50
    }
    
    override func awakeFromNib() {
        //self.dataText?.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DetailsTableViewLinkCellData {
            self.labelText.text = data.labelText
            self.contentText = data.contentText
            if self.labelText.text == "Twitter" {
                self.linkButtonView.setTitle("Twitter Link", for: .normal)
            } else if self.labelText.text == "Website" {
                self.linkButtonView.setTitle("Website Link", for: .normal)
            } else if self.labelText.text == "PDF" {
                self.linkButtonView.setTitle("PDF Link", for: .normal)
            } else {
                self.linkButtonView.setTitle("N.A.", for: .normal)
            }
            
        }
    }
    
    private func openUrl(url:String!) {
        let targetURL = NSURL(string: url)
        UIApplication.shared.open(targetURL as! URL, options: [:], completionHandler: nil)
    }
    
}
