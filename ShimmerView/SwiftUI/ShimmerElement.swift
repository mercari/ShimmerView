import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct ShimmerElement: View {
    @Environment(\.shimmerGeometry)
    private var geometry
    
    @State
    private var baseBounds: CGRect = .zero

    @State
    private var elementFrame: CGRect = .zero
    
    var width: CGFloat?
    
    var height: CGFloat?
    
    var body: some View {
        ShimmerViewWrapper(
            baseBounds: $baseBounds,
            elementFrame: $elementFrame
        )
        .frame(width: width, height: height)
        .anchorPreference(
            key: BoundsPreferenceKey.self,
            value: .bounds,
            transform: { $0 }
        )
        .onPreferenceChange(BoundsPreferenceKey.self) { anchor in
            guard let anchor = anchor, let geometry = geometry else {
                return
            }
            baseBounds = CGRect(origin: .zero, size: geometry.size)
            elementFrame = geometry[anchor]
        }
    }
}

@available(iOS 14.0, *)
private struct BoundsPreferenceKey: PreferenceKey {
    typealias Value = Anchor<CGRect>?
    static var defaultValue: Value = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {}
}

@available(iOS 14.0, *)
struct ShimmerViewWrapper: UIViewRepresentable {
    
    @Binding
    var baseBounds: CGRect
    
    @Binding
    var elementFrame: CGRect
    
    @EnvironmentObject
    var state: ShimmerState
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ShimmerCoreView {
        ShimmerCoreView(frame: .zero)
    }
    
    func updateUIView(_ uiView: ShimmerCoreView, context: Context) {
        uiView.update(
            baseBounds: baseBounds,
            elementFrame: elementFrame,
            style: state.style,
            effectBeginTime: state.effectBeginTime
        )
        
        if uiView.isAnimating != state.isAnimating {
            if state.isAnimating {
                uiView.startAnimating()
            } else {
                uiView.stopAnimating()
            }
        }
    }
    
    class Coordinator {
        init() {}
    }
}


