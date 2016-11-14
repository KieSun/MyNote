//
//  MainViewController.swift
//  MyNote
//
//  Created by 俞诚恺 on 2016/11/14.
//  Copyright © 2016年 sun. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let button = UIButton()
        button.setTitle("点击", for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(MainViewController.tap), for: .touchUpInside)
        
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        let picker = UIDatePicker()
        view.addSubview(picker)
        
        picker.rx.date
            .subscribe { (date) in
            print(date)
            }
            .addDisposableTo(disposeBag)
        
        
        picker.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.width.equalTo(300)
        }
    }

    func tap() {
        
        let vc = RemindViewController()

        
        present(vc, animated: true, completion: nil)
        vc.view.backgroundColor = UIColor.clear
    }
}

