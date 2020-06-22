import UIKit

internal extension CGPoint {
    func add(vector: CGVector) -> CGPoint {
        CGPoint(x: x+vector.dx, y: y+vector.dy)
    }
}
