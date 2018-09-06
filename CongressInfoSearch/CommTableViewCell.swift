//
//  CommTableViewCell.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/26/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit

struct CommTableViewCellData {
    
    init(text: String, detailText: String) {
        self.text = text
        self.detailText = detailText
    }
    var text: String
    var detailText: String
}

class CommTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var detailText: UILabel!
    
    override func awakeFromNib() {
    }
    
    override class func height() -> CGFloat {
        return 50
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? CommTableViewCellData {
            self.dataText.text = data.text
            self.detailText.text = data.detailText
        }
    }
}
