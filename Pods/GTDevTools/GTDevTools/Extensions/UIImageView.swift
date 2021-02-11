//
//  UIImageView.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 5/21/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import UIKit

public var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    open func loadImage(from urlString: String) {
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if url.absoluteString != urlString {
                return
            }
            guard let imageData = data else {return}
            if let photoImage = UIImage(data: imageData) {
                imageCache.setObject(photoImage, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    self.image = photoImage
                }
            }
            }.resume()
    }
    
    convenience public init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill, size: CGSize? = nil, cornerRadius: CGFloat? = nil) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
        if let size = size {
            setSizeAnchors(height: size.height, width: size.width)
        }
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        }
    }
}
