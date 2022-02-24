import SwiftUI
import ShimmerView

@available(iOS 14.0, *)
public struct Placeholder: View {

    @State
    private var isAnimating: Bool = true

    public var body: some View {
        ShimmerScope(isAnimating: $isAnimating) {
            LazyVStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 16)
                ShimmerElement(width: 100, height: 12)
                Spacer(minLength: 16)
                ShimmerElement(height: 60)
                Spacer(minLength: 24)
                ShimmerElement(width: 100, height: 12)
                Spacer(minLength: 16)
                ForEach(0..<8) { _ in
                    HStack(alignment: .center, spacing: 4) {
                        ShimmerElement()
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(4)
                        ShimmerElement()
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(4)
                        ShimmerElement()
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(4)
                    }
                    .padding(.bottom, 4)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    public init() {}
}

