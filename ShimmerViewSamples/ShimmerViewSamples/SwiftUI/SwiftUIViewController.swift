import UIKit
import SwiftUI

@available(iOS 14.0, *)
final class SwiftUIViewController: UIHostingController<Placeholder> {
    init() {
        super.init(rootView: Placeholder())
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
