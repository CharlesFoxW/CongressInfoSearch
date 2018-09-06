//
//  DetailsTableViewCell.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/25/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit

struct DetailsTableViewCellData {
    
    init(labelText: String, contentText: String) {
        self.labelText = labelText
        self.contentText = contentText
    }
    
    var labelText: String
    var contentText: String
}

class DetailsTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var contentText: UILabel!
    
    override class func height() -> CGFloat {
        return 50
    }
    
    override func awakeFromNib() {
        //self.dataText?.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DetailsTableViewCellData {
            self.labelText.text = data.labelText
            self.contentText.text = data.contentText
        }
    }
    
    
}
