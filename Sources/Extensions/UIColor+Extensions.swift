import UIKit

public extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: red, green: green, blue: blue, alpha: alpha)
    }

    func interpolate(with secondColor: UIColor, degree: CGFloat) -> UIColor {
        let degree = min(1.0, max(0.0, degree))
        let first = components
        let second = secondColor.components

        let red = (1-degree)*first.red + degree*second.red
        let green = (1-degree)*first.green + degree*second.green
        let blue = (1-degree)*first.blue + degree*second.blue
        let alpha = (1-degree)*first.alpha + degree*second.alpha

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
