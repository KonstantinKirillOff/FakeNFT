import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // Text Colors
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor.gray
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black

    static let black = UIColor(named: "Black") ?? UIColor()
    static let white = UIColor(named: "White") ?? UIColor()
    static let lightGray = UIColor(named: "Light gray") ?? UIColor()
    static let gray = UIColor(named: "Gray") ?? UIColor()
    static let red = UIColor(named: "Red") ?? UIColor()
    static let background = UIColor(named: "Background") ?? UIColor()
    static let green = UIColor(named: "Green") ?? UIColor()
    static let blue = UIColor(named: "Blue") ?? UIColor()
    static let blackUniversal = UIColor(named: "Black Universal") ?? UIColor()
    static let whiteUniversal = UIColor(named: "White Universal") ?? UIColor()
    static let yellow = UIColor(named: "Yellow") ?? UIColor()
}
