import UIKit

internal extension CGPoint {
    func add(vector: CGVector) -> CGPoint {
        CGPoint(x: x+vector.dx, y: y+vector.dy)
    }
    
    func subtract(vector: CGVector) -> CGPoint {
        CGPoint(x: x-vector.dx, y: y-vector.dy)
    }

    func vector(to: CGPoint) -> CGVector {
        CGVector(dx: to.x - x, dy: to.y - y)
    }
}
