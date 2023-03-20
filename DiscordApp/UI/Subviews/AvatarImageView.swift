//
//  RoundedImageView.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

class AvatarImageView: UIImageView {
    public var isPrepareForReuseEnabled = true
    private let imageLoader = ImageLoader()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
    
    func loadImage(
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
            case .failure:
                completion?(false)
            }
        }
    }
    
    func cancelLoading() {
        imageLoader.cancel()
    }
    
    private func prepareForReuse() {
        layer.removeAllAnimations()
        image = nil
    }
}
