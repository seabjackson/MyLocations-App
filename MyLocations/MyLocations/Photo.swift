//
//  Photo.swift
//  MyLocations
//
//  Created by Seab on 10/27/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

class Photo {
    var imageURL: String?
    var imageData: NSData?
    
    init(imageURL: String?, imageData: NSData?) {
        self.imageURL = imageURL
        self.imageData = imageData
    }
}
