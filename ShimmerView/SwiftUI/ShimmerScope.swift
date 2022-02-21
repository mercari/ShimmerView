import SwiftUI

@available(iOS 14.0, *)
public struct ShimmerScope<Content: View>: View {
    @StateObject private var model: ShimmerState
    @Binding private var isAnimating: Bool
    private let content: () -> Content

    public init(
        style: ShimmerViewStyle = .default,
        isAnimating: Binding<Bool>,
        content: @escaping () -> Content
    ) {
        _model = StateObject(wrappedValue: ShimmerState(style: style))
        _isAnimating = isAnimating
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            content()
                .environment(\.shimmerGeometry, proxy)
                .environmentObject(model)
        }
        .onChange(of: isAnimating) { isAnimating in
            model.setAnimating(isAnimating)
        }
    }
}

@available(iOS 14.0, *)
internal class ShimmerState: ObservableObject {
    let style: ShimmerViewStyle
    @Published var isAnimating: Bool = true
    @Published var effectBeginTime: CFTimeInterval = 0
    
    init(style: ShimmerViewStyle) {
        self.style = style
    }
    
    func setAnimating(_ isAnimating: Bool) {
        if isAnimating {
            effectBeginTime = CACurrentMediaTime()
        }
        self.isAnimating = isAnimating
    }
}

@available(iOS 14.0, *)
internal extension EnvironmentValues {
    var shimmerGeometry: GeometryProxy? {
        get {
            self[ShimmerGeometryKey.self]
        }
        set {
            self[ShimmerGeometryKey.self] = newValue
        }
    }
}

@available(iOS 14.0, *)
private struct ShimmerGeometryKey: EnvironmentKey {
    static var defaultValue: GeometryProxy? = nil
}
