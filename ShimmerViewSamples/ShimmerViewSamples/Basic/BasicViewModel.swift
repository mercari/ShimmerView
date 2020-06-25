import Foundation
import UIKit
import ShimmerView
import Combine

extension BasicViewController {
    class ViewModel {
        
        private var styleDidUpdateClosure: ((ShimmerViewStyle) -> ())?
        let state: CurrentValueSubject<ShimmerViewStyle, Never>
        private let disposeBag = DisposeBag()
        
        init() {
            state = CurrentValueSubject(.default)
            state.removeDuplicates().sink { [weak self] style in
                self?.styleDidUpdateClosure?(style)
            }.add(to: disposeBag)
        }
        
        func bindStyleDidUpdate(closure: @escaping (ShimmerViewStyle) -> ()) {
            styleDidUpdateClosure = closure
        }
        
        func baseColorDidUpdate(color: UIColor) {
            state.mutate(\.baseColor, color)
        }
        
        func highlightColorDidUpdate(color: UIColor) {
            state.mutate(\.highlightColor, color)
        }
        
        func durationDidUpdate(duration: CGFloat) {
            state.mutate(\.duration, CFTimeInterval(duration))
        }
        
        func intervalDidUpdate(interval: CGFloat) {
            state.mutate(\.interval, CFTimeInterval(interval))
        }
        
        func effectSpanDidUpdate(effectSpan: ShimmerView.EffectSpan) {
            state.mutate(\.effectSpan, effectSpan)
        }
        
        func effectAngleDidUpdate(effectAngle: CGFloat) {
            state.mutate(\.effectAngle, effectAngle * CGFloat.pi)
        }
    }
}
