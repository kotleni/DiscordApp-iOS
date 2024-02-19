//
//  ImagePreviewModal.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 18.02.2024.
//

import UIKit

final class ImagePreviewModal: UIViewController {
    override func loadView() {
        super.loadView()
    }
    
    func setImagesUrl(urls: [String]) {
        let views: [UIView] = urls.map {
            let view = CachedImageView(type: .content)
            view.contentMode = .scaleAspectFit
            view.bindData(url: $0)
            return view
        }
        
        
        let carouselView = CarouselView(views: views)
        view = carouselView
        view.backgroundColor = .tertiarySystemBackground
    }
}
