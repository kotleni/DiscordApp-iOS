//
//  ImageGrid.swift
//  DiscordApp
//
//  Created by Вячеслав Макаров on 24.03.2023.
//

import UIKit

final class AttachmentsGrid: UIView {
    var attachmentViews: [UIView] = []
    
    public var attachmentsCount: Int {
        attachmentViews.count
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
        rightStackView.isHidden = attachmentViews.count == 1 ? true : false
        
        attachmentViews.enumerated().forEach { (index, attachmentView) in
            if (index % 2) == 0 && index != 0 {
                rightStackView.addArrangedSubview(attachmentView)
            } else if (index % 2) == 0 && (attachmentViews.count % 2) == 0 {
                rightStackView.addArrangedSubview(attachmentView)
            } else {
                leftStackView.addArrangedSubview(attachmentView)
            }
        }
    }
    
    public func setAttachments(_ attachments: [DiscordAttachment]) {
        attachments.forEach { attachment in
            switch attachment.contentType?.split(separator: "/").first {
                case "image":
                let cachedImageView = CachedImageView(type: .content)
                cachedImageView.contentMode = .scaleAspectFit
                cachedImageView.bindData(url: attachment.url)
                attachmentViews.append(cachedImageView)
                break
            default:
                let label = UILabel()
                label.text = "Unsupported content type: \(attachment.contentType!)"
                attachmentViews.append(label)
                break
            }
        }
        layoutGrid()
    }
    
    public func clearAttachments() {
        leftStackView.removeFullyAllArrangedSubviews()
        rightStackView.removeFullyAllArrangedSubviews()
        attachmentViews.removeAll()
    }
}
