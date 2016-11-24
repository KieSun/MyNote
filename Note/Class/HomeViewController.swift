//
//  HomeViewController.swift
//  Note
//
//  Created by yck on 2016/11/23.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import UIKit
import SnapKit



class HomeViewController: UIViewController {

    fileprivate lazy var remindView: RemindView = {
        
        let remindView = Bundle.main.loadNibNamed("RemindView", owner: nil, options: nil)?.first as! RemindView
        remindView.delegate = self
        remindView.layer.masksToBounds = true
        remindView.layer.cornerRadius = 10
        return remindView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    fileprivate func removeRemindView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.remindView.alpha = 0
        }) { _ in
            self.remindView.removeFromSuperview()
        }
    }

    @IBAction func textAction(_ sender: UIButton) {
    }
    
    @IBAction func remindAction(_ sender: UIButton) {
        
        view.addSubview(remindView)
        remindView.alpha = 0
        
        remindView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 285, height: 210))
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.remindView.alpha = 1
        }
        
    }
    
    
    @IBAction func audioAction(_ sender: UIButton) {
    }
}

extension HomeViewController: RemindViewDelegate {
    
    func cancelAction() {
        
        removeRemindView()
        
    }
    
    func finishAction(_ date: Date) {
        
        removeRemindView()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.setupNotification(date: date)
        
    }
}
