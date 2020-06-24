import UIKit

extension UIColor {
    func image(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image(actions: { rendererContext in
            rendererContext.cgContext.setFillColor(self.cgColor)
            rendererContext.fill(CGRect(origin: .zero, size: size))
        })
    }
}
