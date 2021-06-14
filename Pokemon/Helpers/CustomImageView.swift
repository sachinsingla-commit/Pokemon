//
//  CustomImageView.swift
//  Pokemon
//
//  Created by Sachin's Macbook Pro on 14/06/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.assignColor(UIColor.white)
        self.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            
        }).resume()
    }
    
}

extension UIActivityIndicatorView {
    func assignColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            self.style = .medium
        } else {
            self.style = .gray
        }
        self.color = color
    }
}

