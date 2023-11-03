//
//  Error.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 21.03.2023.
//

import UIKit

extension Error {
    func presetErrorAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: self.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
