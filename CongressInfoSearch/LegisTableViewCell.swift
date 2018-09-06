//
//  LegisTableViewCell.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/24/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit

struct LegisTableViewCellData {
    
    init(imageUrl: String, text: String, detailText: String) {
        self.imageUrl = imageUrl
        self.text = text
        self.detailText = detailText
    }
    var imageUrl: String
    var text: String
    var detailText: String
}

class LegisTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var detailText: UILabel!
    
    override func awakeFromNib() {
        //self.dataText?.font = UIFont.systemFont(ofSize: 14)
    }
    
    override class func height() -> CGFloat {
        return 50
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? LegisTableViewCellData {
            self.dataImage.downloadedFrom(link: data.imageUrl)
            self.dataText.text = data.text
            self.detailText.text = data.detailText
        }
    }
}
