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
