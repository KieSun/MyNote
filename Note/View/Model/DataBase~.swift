//
//  File.swift
//  Note
//
//  Created by yck on 2016/11/25.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import Foundation
import RealmSwift

class DataBase: Object {
    
    dynamic var title: String!
    dynamic var imagedata: Data!
    dynamic var time: String!
    dynamic var content: String!
    dynamic var id: String!
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func saveImage(image: UIImage, completionHandle: () -> ()) {
        
        let model = DataBase()
        
        let currentTime = Date.getCurrentTimeString()
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        model.title = "照片于 \(currentTime) 拍摄"
        model.imagedata = imageData
        model.id = currentTime
        model.time = currentTime
        
        do {
            let relam = try Realm()
            
            try relam.write {
                relam.add(model)
            }
            
            completionHandle()
            
        } catch  {
            print(error)
        }

    }
}
