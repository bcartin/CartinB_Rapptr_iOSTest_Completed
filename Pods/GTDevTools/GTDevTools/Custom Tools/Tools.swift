//
//  Tools.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 5/24/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import UIKit

open class GTTools {
    
    public init() {}
    public static let shared = GTTools()
    
    public func resizeImage(image: UIImage, maxSize: CGSize = CGSize(width: 400, height: 700)) -> UIImage {
        var returnImage : UIImage = UIImage()
        var actualHeight = image.size.height
        var actualWidth = image.size.width
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        var imageRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imageRatio < maxRatio {
                imageRatio = maxHeight / actualHeight
                actualWidth = imageRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imageRatio > maxRatio{
                imageRatio = maxWidth / actualWidth
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        if let img = UIGraphicsGetImageFromCurrentImageContext() {
            if let imageData = img.jpegData(compressionQuality: 1.0) {
                UIGraphicsEndImageContext()
                returnImage = UIImage(data: imageData)!
            }
        }
        return returnImage
    }
    
    public func loadImage(from urlString: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        if let url = URL(string: urlString) {
            var image: UIImage?
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if url.absoluteString != urlString {
                    return
                }
                guard let imageData = data else {return}
                if let photoImage = UIImage(data: imageData) {
                    imageCache.setObject(photoImage, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        image = photoImage
                    }
                }
                }.resume()
            return image
        }
        else {
            return nil
        }
    }
}
