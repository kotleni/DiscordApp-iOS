//
//  RoundedImageView.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

/// ImageView for avatar, can generate single char image
class AvatarImageView: UIImageView {
    private lazy var charLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor(named: "Discord")
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 22)
        view.textAlignment = .center
        return view
    }()
    
    private let imageLoader = ImageLoader()
    private var isSingleCharMode: Bool = false
    
    var isPrepareForReuseEnabled = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
        
        if isSingleCharMode {
            charLabel.frame = bounds
        }
    }
    
    private func prepareForReuse() {
        layer.removeAllAnimations()
        image = nil
        disbleSingleCharMode()
    }
    
    private func setSingleChar(char: Character) {
        isSingleCharMode = true
        charLabel.text = "\(char)"
        addSubview(charLabel)
    }
    
    private func disbleSingleCharMode() {
        isSingleCharMode = false
        charLabel.removeFromSuperview()
    }
    
    private func loadImage(
        _ path: String,
        withRenderMode mode: UIImage.RenderingMode? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isPrepareForReuseEnabled { prepareForReuse() }
        imageLoader.image(for: path) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let image):
                self.image = image.withRenderingMode(mode ?? .automatic)
                completion?(true)
                self.disbleSingleCharMode()
            case .failure:
                completion?(false)
            }
        }
    }
    
    private func cancelLoading() {
        imageLoader.cancel()
    }
    
    func bindData(name: String, url: String?) {
        setSingleChar(char: name.first ?? "-")
        guard let url = url else { return }
        loadImage(url)
    }
}
