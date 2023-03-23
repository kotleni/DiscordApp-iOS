// swiftlint:disable all
import UIKit

enum Assets {
    static let accentColor = ColorAsset(name: "AccentColor")
    enum Colors {
        static let background = ColorAsset(name: "Background")
        static let buttonColor = ColorAsset(name: "ButtonColor")
        static let discord = ColorAsset(name: "Discord")
        static let divider = ColorAsset(name: "Divider")
        static let guildSelector = ColorAsset(name: "GuildSelector")
        static let plane = ColorAsset(name: "Plane")
        static let textFieldBackground = ColorAsset(name: "TextFieldBackground")
    }
}

final class ColorAsset {

    fileprivate(set) var name: String

    fileprivate init(name: String) {
        self.name = name
    }

    private(set) lazy var color: UIColor = {
        if let color = UIColor(named: name) {
            return color
        } else {
            fatalError("Unable to load color asset named \(name)")
        }
    }()

    func color(compatibleWith traitCollection: UITraitCollection) -> UIColor {
        if let color = UIColor(named: name, in: nil, compatibleWith: traitCollection) {
            return color
        } else {
            fatalError("Unable to load color asset named \(name)")
        }
    }
}
