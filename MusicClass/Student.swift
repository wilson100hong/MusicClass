//
//  Student.swift
//  MusicClass
//
//  Created by Wilson Hong on 1/29/18.
//  Copyright © 2018 Grace. All rights reserved.
//

import UIKit
import os.log

class Student: NSObject, NSCoding {
    var name: String
    var phone: String?
    var image: UIImage?
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("students")
    
    struct PropertyKey {
        static let name = "name"
        static let phone = "phone"
        static let image = "image"
    }
    
    init?(name: String, phone: String?, image: UIImage?) {
        guard !name.isEmpty else {
            return nil
        }
        self.name = name
        self.phone = phone
        self.image = image
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(phone, forKey: PropertyKey.phone)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let phone = aDecoder.decodeObject(forKey: PropertyKey.phone) as? String
        // Because photo is an optional property of Meal, just use conditional cast.
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        // Must call designated initializer.
        self.init(name: name, phone: phone, image: image)
    }
}
