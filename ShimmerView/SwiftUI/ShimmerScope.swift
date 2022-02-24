import SwiftUI

@available(iOS 14.0, *)
public struct ShimmerScope<Content: View>: View {
    @StateObject private var state = ShimmerState()
    @Binding private var isAnimating: Bool
    private let style: ShimmerViewStyle
    private let content: () -> Content

    public init(
        style: ShimmerViewStyle = .default,
        isAnimating: Binding<Bool>,
        content: @escaping () -> Content
    ) {
        self.style = style
        _isAnimating = isAnimating
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            content()
                .environment(\.shimmerGeometry, proxy)
                .environmentObject(state)
        }
        .onAppear {
            state.style = style
            state.setAnimating(isAnimating)
        }
        .onChange(of: isAnimating) { isAnimating in
            state.setAnimating(isAnimating)
        }
    }
}

@available(iOS 14.0, *)
internal class ShimmerState: ObservableObject {
    @Published var style: ShimmerViewStyle = .default
    @Published var isAnimating: Bool = false
    @Published var effectBeginTime: CFTimeInterval = 0

    func setAnimating(_ isAnimating: Bool) {
        if self.isAnimating != isAnimating && isAnimating {
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
