//
//  ImageGrid.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 24.03.2023.
//

import UIKit

final class AttachmentsGrid: UIView {
    var cachedImageViews: [CachedImageView] = []
    
    public var attachmentsCount: Int {
        cachedImageViews.count
    }

    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3.0
//        stackView.backgroundColor = .blue
        stackView.contentMode = .topLeft
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .green
        stackView.spacing = 3.0
        stackView.distribution = .fillEqually
        return  stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3.0
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGUISettings()
        setUpContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGUISettings() {
        horizontalStackView.addArrangedSubview(leftStackView)
        horizontalStackView.addArrangedSubview(rightStackView)
        
        [horizontalStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    private func setUpContraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func layoutGrid() {
        rightStackView.isHidden = cachedImageViews.count == 1 ? true : false
        
        cachedImageViews.enumerated().forEach { (index, cachedImageView) in
            if (index % 2) == 0 && index != 0 {
                rightStackView.addArrangedSubview(cachedImageView)
            } else if (index % 2) == 0 && (cachedImageViews.count % 2) == 0 {
                rightStackView.addArrangedSubview(cachedImageView)
            } else {
                leftStackView.addArrangedSubview(cachedImageView)
            }
        }
    }
    
    public func setAttachments(_ attachments: [DiscordAttachment]) {
        attachments.forEach { attachment in
            let cachedImageView = CachedImageView(type: .content)
            cachedImageView.contentMode = .scaleAspectFit
            cachedImageView.bindData(url: attachment.url)
            cachedImageViews.append(cachedImageView)
        }
        layoutGrid()
    }
    
    public func clearAttachments() {
        leftStackView.removeFullyAllArrangedSubviews()
        rightStackView.removeFullyAllArrangedSubviews()
        cachedImageViews.removeAll()
    }
}
