//
//  ViewController.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 17.02.2024.
//

import UIKit

class ViewController<T: UIView>: UIViewController {
    
    // Необходимо для правильной работы FluentDarkModeKit при открытии ViewController через .present
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        ServiceLocator.themeService.current == .dark ? .lightContent : .default
//    }
    
    // let errorController: ErrorController
    //let loadingAlert = UIAlertController(title: nil, message: Text.alertWaitloading, preferredStyle: .alert)
    
    private var viewDidAppearTasks: [() -> Void]? = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearTasks?.forEach { task in task() }
        viewDidAppearTasks = nil
    }
    /*
     Выполнение кода гарантировано будет исполнено после того как сработает viewDidAppear
     */
    func executeWhenViewAlreadyAppeared(executionBlock: @escaping () -> Void) {
        if viewDidAppearTasks != nil {
            viewDidAppearTasks?.append(executionBlock)
        } else {
            executionBlock()
        }
    }
    
    func setLoading(isLoading: Bool) {
        switch isLoading {
        case true:
            showToast(duration: 20)
        case false:
            hideToast()
        }
    }
    
    var mainView: T {
        if let view = view as? T {
            return view
        } else {
            let view = T()
            self.view = view
            return view
        }
    }
    
    init() {
        //errorController = ErrorController()
        super.init(nibName: nil, bundle: nil)
        // errorController.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let mainView = T()
        mainView.backgroundColor = .systemBackground
        self.view = mainView
    }
    
//    func presentError(_ displayedError: DisplayedError, into view: UIView? = nil) {
//        errorController.presentError(displayedError, into: view ?? mainView)
//    }
//
//    func errorController(_ errorController: ErrorController, primaryButtonPressed primaryButton: ActivityButton) {
//        errorController.startActivityAnimating()
//    }
//
//    func errorController(_ errorController: ErrorController, secondaryButtonPressed secondaryButton: UIButton) {
//
//    }
}
