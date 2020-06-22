import UIKit

internal extension CGRect {
    var mid: CGPoint {
        CGPoint(x: midX, y: midY)
    }

    var diagonalDistance: CGFloat {
        sqrt(width*width+height*height)
    }
}
