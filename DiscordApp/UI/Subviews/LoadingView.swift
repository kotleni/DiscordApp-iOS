//
//  ToastView.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 17.02.2024.
//

import UIKit

// TODO: Rename
final class ToastView: UIView {
    private let indicator = UIActivityIndicatorView()
    
    private var isShown: Bool { showTimer != nil }
    private weak var showTimer: Timer?
    private var fadeOutAnimation: UIViewPropertyAnimator?
    
    private var completion: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 16.0
        indicator.style = .medium
        indicator.startAnimating()
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: topAnchor),
            indicator.leftAnchor.constraint(equalTo: leftAnchor),
            indicator.rightAnchor.constraint(equalTo: rightAnchor),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func insert(into superview: UIView) {
        superview.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.topAnchor,
                constant: 16.0
            ),
            leftAnchor.constraint(
                equalTo: superview.leftAnchor,
                constant: 16.0
            ),
            centerXAnchor.constraint(
                equalTo: superview.centerXAnchor
            ),
        ])
    }
    
    func insert(into viewController: UIViewController) {
        viewController.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        var superviewTopAnchor = viewController.view.safeAreaLayoutGuide.topAnchor
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            widthAnchor.constraint(equalToConstant: 100),
            heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func update(duration: TimeInterval?, completion: (() -> Void)?) {
        self.completion = completion

        showTimer?.invalidate()
        attractedAttention()
        setupShowTimer(duration: duration)
    }
    
    func show(duration: TimeInterval?, completion: (() -> Void)?) {
        self.completion = completion
        fadeOutAnimation?.stopAnimation(true)
        fadeInView()
        setupShowTimer(duration: duration)
    }
    
    private func attractedAttention() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.transform = .identity
            }
        }
    }
    
    private func fadeInView() {
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
            self?.alpha = 1.0
            self?.transform = .identity
        }
    }
    
    private func setupShowTimer(duration: TimeInterval?) {
        guard let duration else { return }
        
        let timer = Timer(timeInterval: duration, repeats: false) { [weak self] _ in
            self?.fadeOutView()
        }
        showTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func fadeOutView() {
        let fadeOutAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut)
        fadeOutAnimation.addAnimations { [weak self] in
            self?.alpha = 0.0
            self?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        fadeOutAnimation.addCompletion { [weak self] position in
            if position == .end {
                self?.removeFromSuperview()
                self?.completion?()
                self?.completion = nil
                self?.fadeOutAnimation = nil
            }
        }
        self.fadeOutAnimation = fadeOutAnimation
        fadeOutAnimation.startAnimation()
    }
    
    func hide() {
        showTimer?.invalidate()
        fadeOutView()
    }
    
    deinit {
        showTimer?.invalidate()
    }
}

extension UIViewController {
    private var subviewToast: ToastView? {
        view.subviews.first { $0 is ToastView } as? ToastView
    }
    private var navigationBarToast: ToastView? {
        navigationController?.navigationBar.superview?.subviews.first { $0 is ToastView } as? ToastView
    }
    private var toastView: ToastView? {
        subviewToast ?? navigationBarToast
    }
    
    func showToast(
        duration: TimeInterval? = nil,
        completion: (() -> Void)? = nil
    ) {
        if let toastView {
            toastView.update(
                duration: duration,
                completion: completion
            )
            return
        }
        
        let toastView = ToastView()
        toastView.alpha = 0.0
        toastView.insert(into: self)
        toastView.show(duration: duration, completion: completion)
    }
    
    func hideToast() {
        toastView?.hide()
    }
}
