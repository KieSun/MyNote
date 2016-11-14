//
//  RemindViewController.swift
//  MyNote
//
//  Created by 俞诚恺 on 2016/11/14.
//  Copyright © 2016年 sun. All rights reserved.
//

import UIKit

class RemindViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        
        let view1 = UIView()
        view1.backgroundColor = UIColor.blue
        view.addSubview(view1)
        
        view1.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.width.equalTo(200)
        }
        
        
    }

    
}
