//
//  UIImage+Resize.swift
//  MyLocations
//
//  Created by Seab on 9/10/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit

extension UIImage {
    
    // resize image before adding to the table view as thumbnail
    func resizedImageWithBounds(bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        drawInRect(CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
