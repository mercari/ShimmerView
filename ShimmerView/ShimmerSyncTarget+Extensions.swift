import UIKit

public extension ShimmerSyncTarget {
    var baseColor: UIColor {
        return UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
    }

    var highlightColor: UIColor {
        return UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
    }

    var duration: CFTimeInterval {
        1.2
    }

    var interval: CFTimeInterval {
        0.4
    }

    var effectBeginTime: CFTimeInterval {
        0
    }

    var effectSpan: ShimmerView.EffectSpan {
        .points(120)
    }

    var effectAngle: CGFloat {
        0
    }
}
