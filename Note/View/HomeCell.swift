//
//  HomeCell.swift
//  Note
//
//  Created by yck on 2016/11/28.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var model: DataBase? {
        didSet {
            
            titleLabel.text = model?.title!
            contentLabel.text = model?.time!
            
            iconImage.image = UIImage(data: (model?.imagedata)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
