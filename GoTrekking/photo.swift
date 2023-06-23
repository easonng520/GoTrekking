//
//  photo.swift
//  GoTrekking
//
//  Created by eazz on 23/6/2023.
//

import UIKit

class Photo: NSObject, Codable {
    var imageFileName: String
    var caption: String
    
    init(imageFileName: String, caption: String) {
        self.imageFileName = imageFileName
        self.caption = caption
    }
}

