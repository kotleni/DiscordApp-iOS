//
//  CarouselView.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 18.02.2024.
//

import UIKit

final class CarouselView: UIView, UIScrollViewDelegate {
    var views: [UIView] = []
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.bounds.contains(point) {
            return scrollView
        }
        return super.hitTest(point, with: event)
    }
    
    init(views: [UIView]) {
        super.init(frame: .zero)
        
        self.views = views
        
        scrollView.delegate = self
        
        setupSubviews()
        setupLayoutConstraints()
        
        for view in views {
            stackView.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            ])
        }
        
        // so we can see the views that are outside the frame of the scroll view
        scrollView.clipsToBounds = false
        
        // let's give the scroll view a border to make it clear
        scrollView.layer.borderWidth = 0
        //scrollView.layer.borderColor = UIColor.black.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        
        let cg = scrollView.contentLayoutGuide
        let fg = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 150.0),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.90),
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: cg.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: cg.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cg.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: cg.bottomAnchor),
            
            stackView.heightAnchor.constraint(equalTo: fg.heightAnchor),
            
        ])
    }
    
    // MARK: - UI Components
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
    }()
}
