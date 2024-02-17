//
//  ViewController.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 17.02.2024.
//

import UIKit

class ViewController<T: UIView>: UIViewController {
    private var viewDidAppearTasks: [() -> Void]? = []
    
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
        super.init(nibName: nil, bundle: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearTasks?.forEach { task in task() }
        viewDidAppearTasks = nil
    }
    
    /*
     Closure garanted to be called after viewDidAppear
     */
    func executeWhenViewAlreadyAppeared(executionBlock: @escaping () -> Void) {
        if viewDidAppearTasks != nil {
            viewDidAppearTasks?.append(executionBlock)
        } else {
            executionBlock()
        }
    }
    
    /*
     Update loading view state
     */
    func setLoading(isLoading: Bool) {
        switch isLoading {
        case true:
            showLoadingView()
        case false:
            hideLoadingView()
        }
    }
}
