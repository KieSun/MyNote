//
//  RemindView.swift
//  Note
//
//  Created by yck on 2016/11/23.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import UIKit

@objc protocol RemindViewDelegate {
    
    func cancelAction()
    func finishAction(_ date: Date)
}

class RemindView: UIView {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: RemindViewDelegate?

    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        delegate?.cancelAction()
        
    }
    
    
    @IBAction func finishAction(_ sender: UIButton) {
        
        delegate?.finishAction(datePicker.date)
    }
}
