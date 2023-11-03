//
//  Coordinator.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 24.03.2023.
//

import UIKit

final class Coordinator {
    private weak var navigationController: UINavigationController?
    
    func openMain(with window: UIWindow) {
        let viewController = MainViewController()
        viewController.coordinator = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.navigationController = navigationController
    }
    
    func openAuth(with authVCDelegate: AuthViewControllerDelegate) {
        let viewController = AuthViewController()
        viewController.coordinator = self
        viewController.delegate = authVCDelegate
        navigationController?.modalPresentationStyle = .popover
        navigationController?.present(viewController, animated: true)
    }
    
    func openMessages(channel: DiscordChannel) {
        let viewController = MessagesViewController(channel: channel)
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
