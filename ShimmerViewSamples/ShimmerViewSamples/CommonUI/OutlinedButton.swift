import UIKit

class OutlinedButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.magenta.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 32).isActive = true
        titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel?.font = .preferredFont(forTextStyle: .body)
        
        setTitleColor(.magenta, for: .normal)
        setTitleColor(.systemBackground, for: .selected)
        
        setBackgroundImage(UIColor.clear.image(size: CGSize(width: 1, height: 1)), for: .normal)
        setBackgroundImage(UIColor.magenta.image(size: CGSize(width: 1, height: 1)), for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let width = (titleLabel?.intrinsicContentSize.width ?? 0) + titleEdgeInsets.left + titleEdgeInsets.right
        return CGSize(width: width, height: super.intrinsicContentSize.height)
    }
}
