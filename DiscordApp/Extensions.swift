//
//  Extensions.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

extension Error {
    func presetErrorAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: self.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in }))
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension URLResponse {
    func verify() -> NetworkingError? {
        guard let code, let url else {
            return .invalidRequest(url)
        }
        switch code {
        case 200...299:
            return nil
        default:
            let localizedString = HTTPURLResponse.localizedString(forStatusCode: code)
            let description = "\(url) - \(code) - \(localizedString)"
            return .badStatusCode(description, code: code)
        }
    }
    
    var code: Int? {
        if let http = self as? HTTPURLResponse {
            return http.statusCode
        } else {
            return nil
        }
    }
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
