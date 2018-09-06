//
//  BillsTableViewCell.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/26/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit

struct BillsTableViewCellData {
    
    init(text: String, id: String, time: String) {
        self.text = text
        self.id = id
        self.time = time
    }
    var text: String
    var id: String
    var time: String
}

class BillsTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var idText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    
    override func awakeFromNib() {
    }
    
    override class func height() -> CGFloat {
        return 100
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? BillsTableViewCellData {
            self.dataText.text = data.text
            self.idText.text = data.id
            self.timeText.text = data.time
        }
    }
}
