//
//  HomeViewController.swift
//  Note
//
//  Created by yck on 2016/11/23.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

typealias AllTableViewProtocol = UITableViewDelegate & UITableViewDataSource


class HomeViewController: UIViewController {
    
    var token: NotificationToken?

    fileprivate lazy var remindView: RemindView = {
        
        let remindView = Bundle.main.loadNibNamed("RemindView", owner: nil, options: nil)?.first as! RemindView
        remindView.delegate = self
        remindView.layer.masksToBounds = true
        remindView.layer.cornerRadius = 10
        return remindView
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray: Array<DataBase>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        token = realm.addNotificationBlock { notification, realm in
            self.updateUI()
        }
        
        
    }
    
    deinit {
        token?.stop()
    }
    
    fileprivate func updateUI() {
        
        let realm = try! Realm()
        
        dataArray = Array(realm.objects(DataBase.self))
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
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

extension HomeViewController: AllTableViewProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        
        cell.model = dataArray?[indexPath.row]
        return cell
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
