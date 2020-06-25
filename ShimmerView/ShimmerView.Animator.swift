import UIKit
import simd

extension ShimmerSyncTarget {
    var effectDiameter: CGFloat {
        return syncTargetView.frame.diagonalDistance
    }

    var effectRadius: CGFloat {
        return effectDiameter / 2
    }

    var effectWidth: CGFloat {
        switch style.effectSpan {
        case .ratio(let ratio):
            return effectDiameter*ratio
        case .points(let points):
            return points
        }
    }
}

internal extension ShimmerView {
    class Animator {
        let shimmerView: ShimmerView
        let syncTarget: ShimmerSyncTarget
        
        init(shimmerView: ShimmerView) {
            self.shimmerView = shimmerView
            self.syncTarget = shimmerView.nearestShimmerSyncTarget ?? shimmerView
        }
        
        var interpolatedColors: [Any] {
            let baseColor = syncTarget.style.baseColor
            let highlightColor = syncTarget.style.highlightColor
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
        
        lazy var effectRadius: CGFloat = {
            let baseAngle = atan(syncTarget.syncTargetView.frame.height / syncTarget.syncTargetView.frame.width)
            let first = abs(cos(baseAngle - syncTarget.style.effectAngle))*syncTarget.effectRadius
            let second = abs(cos(baseAngle - syncTarget.style.effectAngle+CGFloat.pi*0.5))*syncTarget.effectRadius
            return max(first, second)
        }()
        
        var vectorFromViewCenterToStartPointFrom: CGVector {
            let distance = effectRadius + syncTarget.effectWidth
            let fromVector = CGVector(dx: -distance*cos(syncTarget.style.effectAngle), dy: -distance*sin(syncTarget.style.effectAngle))
            return fromVector
        }
        
        var vectorFromViewCenterToStartPointTo: CGVector {
            let distance = effectRadius
            let fromVector = CGVector(dx: distance*cos(syncTarget.style.effectAngle), dy: distance*sin(syncTarget.style.effectAngle))
            return fromVector
        }
        
        var vectorFromViewCenterToEndPointFrom: CGVector {
            let distance = effectRadius
            let fromVector = CGVector(dx: -distance*cos(syncTarget.style.effectAngle), dy: -distance*sin(syncTarget.style.effectAngle))
            return fromVector
        }
        
        var vectorFromViewCenterToEndPointTo: CGVector {
            let distance = effectRadius + syncTarget.effectWidth
            let fromVector = CGVector(dx: distance*cos(syncTarget.style.effectAngle), dy: distance*sin(syncTarget.style.effectAngle))
            return fromVector
        }
        
        func calculateTargetPoint(with vectorFromViewCenter: CGVector) -> CGPoint {
            let pointOnSyncTargetView = syncTarget.syncTargetView.bounds.mid.add(vector: vectorFromViewCenter)
            
            // convert coordinate space from sync target view to gradient layer
            let toConverted = syncTarget.syncTargetView.convert(pointOnSyncTargetView, to: shimmerView)
            let converted = shimmerView.layer.convert(toConverted, to: shimmerView.gradientLayer)
            
            // convert point on gradient layer to ratio
            let denominator = shimmerView.gradientLayer.frame.width
            return CGPoint(x: converted.x / denominator, y: converted.y / denominator)
        }
        
        var startPointAnimationFromValue: CGPoint {
            calculateTargetPoint(with: vectorFromViewCenterToStartPointFrom)
        }
        
        var startPointAnimationToValue: CGPoint {
            calculateTargetPoint(with: vectorFromViewCenterToStartPointTo)
        }
        
        var endPointAnimationFromValue: CGPoint {
            calculateTargetPoint(with: vectorFromViewCenterToEndPointFrom)
        }
        
        var endPointAnimationToValue: CGPoint {
            calculateTargetPoint(with: vectorFromViewCenterToEndPointTo)
        }
        
        var startPointAnimation: CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "startPoint")
            animation.fromValue = startPointAnimationFromValue
            animation.toValue = startPointAnimationToValue
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            return animation
        }
        
        var endPointAnimation: CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "endPoint")
            animation.fromValue = endPointAnimationFromValue
            animation.toValue = endPointAnimationToValue
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            return animation
        }
     
        var gradientLayerAnimation: CAAnimationGroup {
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [startPointAnimation, endPointAnimation]
            groupAnimation.duration = syncTarget.style.duration
            groupAnimation.fillMode = .both

            let animation = CAAnimationGroup()
            animation.animations = [groupAnimation]
            animation.duration = syncTarget.style.duration + syncTarget.style.interval
            animation.repeatCount = .infinity
            animation.fillMode = .both
            animation.isRemovedOnCompletion = false
            animation.beginTime = syncTarget.effectBeginTime
            animation.timeOffset = (CACurrentMediaTime()-syncTarget.effectBeginTime).truncatingRemainder(dividingBy: syncTarget.style.duration)
            return animation
        }
    }
}
