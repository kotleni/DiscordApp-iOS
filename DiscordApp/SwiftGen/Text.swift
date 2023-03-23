// swiftlint:disable all
import Foundation

/*

 Стандартный нейминг:
 "модуль"."элемент" -> "onboarding.helloButton"

 Если элемент принимает несколько текстовых параметров:
 "модуль"."элемент"."параметр" -> "login.textfield.placeholder"

*/

enum Text {
    /// Localizable.strings
    ///   DiscordApp
    /// 
    ///   Created by Victor Varenik on 23.03.2023.
    static let alertWaitloading = Text.tr("Localizable", "alert_waitloading", fallback: "Loading...")
    /// Enter message...
    static let hintEntermsg = Text.tr("Localizable", "hint_entermsg", fallback: "Enter message...")
}

extension Text {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {
    static let bundle: Bundle = {
        Bundle(for: BundleToken.self)
    }()
}

