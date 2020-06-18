import Foundation
import UIKit
import simd

extension ShimmerSyncTarget {
    var effectDiameter: CGFloat {
        return syncTargetView.frame.diagonalDistance
    }

    var effectWidth: CGFloat {
        switch effectSpan {
        case .ratio(let ratio):
            return effectDiameter*ratio
        case .points(let points):
            return points
        }
    }
}

extension CGRect {
    var mid: CGPoint {
        CGPoint(x: midX, y: midY)
    }

    var diagonalDistance: CGFloat {
        sqrt(width*width+height*height)
    }
}

extension CGPoint {
    func add(vector: CGVector) -> CGPoint {
        CGPoint(x: x+vector.dx, y: y+vector.dy)
    }
}

private extension UIResponder {
    var nearestShimmerSyncTarget: (ShimmerSyncTarget & UIResponder)? {
        var current: UIResponder? = self.next
        while current != nil {
            if let syncTarget = current as? (ShimmerSyncTarget & UIResponder) {
                return syncTarget
            } else {
                current = current?.next
            }
        }
        return nil
    }
}

open class ShimmerView: UIView, ShimmerSyncTarget, ShimmerReplicatorViewCell {
    public typealias Input = Void

    private static let animationKey = "ShimmerEffect"

    public var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()

    private func interpolationColors(baseColor: UIColor, highlightColor: UIColor) -> [Any] {
        let numberOfSteps = 30
        let baseColors: [UIColor] = [baseColor, highlightColor, baseColor]
        var colors: [UIColor] = []
        for i in 0..<baseColors.count-1 {
            let lengthOfStep = 1.0/Float(numberOfSteps)
            let newColors = stride(from: 0.0, to: 1.0, by: lengthOfStep).map {
                baseColors[i].interpolate(with: baseColors[i+1], degree: CGFloat(simd_smoothstep(0.0, 1.0, $0)))
            }
            colors += newColors
        }
        colors.append(baseColors[baseColors.count-1])
        return colors.map { $0.cgColor }
    }

    private(set) var isAnimating: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
    }

    public func startAnimating() {
        isAnimating = true
        gradientLayer.removeAnimation(forKey: ShimmerView.animationKey)

        // Find the nearest ShimmerSyncTarget
        let syncTarget = self.nearestShimmerSyncTarget ?? self

        if gradientLayer.colors == nil {
            gradientLayer.colors = interpolationColors(baseColor: syncTarget.baseColor, highlightColor: syncTarget.highlightColor)
        }

        let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
        let startPoints = ViewModel.calculateStartPoint(syncTarget: syncTarget, shimmerView: self)
        startPointAnimation.fromValue = startPoints.from
        startPointAnimation.toValue = startPoints.to
        startPointAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
        let endPoints = ViewModel.calculateEndPoint(syncTarget: syncTarget, shimmerView: self)
        endPointAnimation.fromValue = endPoints.from
        endPointAnimation.toValue = endPoints.to
        endPointAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [startPointAnimation, endPointAnimation]
        groupAnimation.duration = syncTarget.duration
        groupAnimation.fillMode = .both

        let animationForInterval = CAAnimationGroup()
        animationForInterval.animations = [groupAnimation]
        animationForInterval.duration = syncTarget.duration + syncTarget.interval
        animationForInterval.repeatCount = .infinity
        animationForInterval.fillMode = .both
        animationForInterval.isRemovedOnCompletion = false
        animationForInterval.beginTime = syncTarget.effectBeginTime
        animationForInterval.timeOffset = (CACurrentMediaTime()-syncTarget.effectBeginTime).truncatingRemainder(dividingBy: syncTarget.duration)

        gradientLayer.add(animationForInterval, forKey: ShimmerView.animationKey)
    }

    public func stopAnimating() {
        isAnimating = false
        gradientLayer.removeAnimation(forKey: ShimmerView.animationKey)
        gradientLayer.colors = nil
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if frame.width > frame.height {
            gradientLayer.frame.origin = CGPoint(x: 0, y: -(frame.width - frame.height)/2)
            gradientLayer.frame.size = CGSize(width: frame.width, height: frame.width)
        } else if frame.height > frame.width {
            gradientLayer.frame.origin = CGPoint(x: -(frame.height - frame.width)/2, y: 0)
            gradientLayer.frame.size = CGSize(width: frame.height, height: frame.height)
        } else {
            gradientLayer.frame = bounds
        }

        if isAnimating {
            startAnimating()
        }
    }
}

extension ShimmerView {
    struct ViewModel {
        static func calculateStartPoint(syncTarget: ShimmerSyncTarget, shimmerView: ShimmerView) -> (from: CGPoint, to: CGPoint) {
            let syncTargetView = syncTarget.syncTargetView
            let effectWidth = syncTarget.effectWidth
            let radius = syncTarget.effectDiameter / 2
            let angle = syncTarget.effectAngle

            let baseAngle = atan(syncTargetView.frame.height / syncTargetView.frame.width)
            let effectRadius = abs(cos(baseAngle - angle)*radius)

            let fromDistance = effectRadius + effectWidth
            let toDistance = effectRadius
            let denominator = max(shimmerView.frame.width, shimmerView.frame.height)

            let fromVector = CGVector(dx: -fromDistance*cos(angle), dy: -fromDistance*sin(angle))
            let from = syncTargetView.bounds.mid.add(vector: fromVector)
            var fromConverted = syncTargetView.convert(from, to: shimmerView)
            fromConverted = shimmerView.layer.convert(fromConverted, to: shimmerView.gradientLayer)
            let fromPoint = CGPoint(x: fromConverted.x / denominator, y: fromConverted.y/denominator)

            let toVector = CGVector(dx: toDistance*cos(angle), dy: toDistance*sin(angle))
            let to = syncTargetView.bounds.mid.add(vector: toVector)
            var toConverted = syncTargetView.convert(to, to: shimmerView)
            toConverted = shimmerView.layer.convert(toConverted, to: shimmerView.gradientLayer)
            let toPoint = CGPoint(x: toConverted.x / denominator, y: toConverted.y / denominator)

            return (from: fromPoint, to: toPoint)
        }

        static func calculateEndPoint(syncTarget: ShimmerSyncTarget, shimmerView: ShimmerView) -> (from: CGPoint, to: CGPoint) {
            let syncTargetView = syncTarget.syncTargetView
            let effectWidth = syncTarget.effectWidth
            let radius = syncTarget.effectDiameter / 2
            let angle = syncTarget.effectAngle

            let baseAngle = atan(syncTargetView.frame.height / syncTargetView.frame.width)
            let effectRadius = abs(cos(baseAngle - angle)*radius)

            let fromDistance: CGFloat = effectRadius
            let toDistance: CGFloat = effectRadius + effectWidth
            let denominator = max(shimmerView.frame.width, shimmerView.frame.height)

            let fromVector = CGVector(dx: -fromDistance*cos(angle), dy: -fromDistance*sin(angle))
            let from = syncTargetView.bounds.mid.add(vector: fromVector)
            var fromConverted = syncTargetView.convert(from, to: shimmerView)
            fromConverted = shimmerView.layer.convert(fromConverted, to: shimmerView.gradientLayer)
            let fromPoint = CGPoint(x: fromConverted.x / denominator, y: fromConverted.y / denominator)

            let toVector = CGVector(dx: toDistance*cos(angle), dy: toDistance*sin(angle))
            let to = syncTargetView.bounds.mid.add(vector: toVector)
            var toConverted = syncTargetView.convert(to, to: shimmerView)
            toConverted = shimmerView.layer.convert(toConverted, to: shimmerView.gradientLayer)
            let toPoint = CGPoint(x: toConverted.x / denominator, y: toConverted.y / denominator)

            return (from: fromPoint, to: toPoint)
        }
    }
}

public extension ShimmerView {
    enum EffectSpan {
        case ratio(CGFloat)
        case points(CGFloat)
    }
}

