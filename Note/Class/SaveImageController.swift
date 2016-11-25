//
//  SaveImageController.swift
//  Note
//
//  Created by yck on 2016/11/25.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import UIKit
import RealmSwift

class SaveImageController: UIViewController {

    @IBOutlet weak var uiimageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiimageView.image = image
    }
    

    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveImage(_ sender: UIButton) {
        
        guard let image = image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(SaveImageController.image(image:didFinishSavingWithError:contextInfo:)), nil)
        
        
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        DataBase.saveImage(image: image) {
            print("保存成功")
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}
