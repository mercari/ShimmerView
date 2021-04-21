import UIKit

/// ShimmerReplicatorView
/// This class replicates the specified `ShimmerReplicatorViewCell` inside its frame in horizontal and vertical direction.
/// This class make it easy to create list type loading indicator very easily.
public class ShimmerReplicatorView: UIView {

    public enum ItemSize {
        case fixedSize(CGSize)
        case fixedHeight(CGFloat)
    }

    public enum EdgeMode {
        /// Replicate cells within the edge
        /*
         |----------------------------|
         | |--------| |--------|      |
         | |  cell  | |  cell  |      |
         | |--------| |--------|      |
         |----------------------------|
         */
        case within

        /// Replicate cells beyond the edge
        /*
         |----------------------------|
         | |--------| |--------| |----|---|
         | |  cell  | |  cell  | |    |   |
         | |--------| |--------| |----|---|
         |----------------------------|
         */
        case beyond
    }

    public override class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }

    private var replicatorLayer: CAReplicatorLayer {
        return layer as! CAReplicatorLayer
    }

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) var isAnimating: Bool = false

    public private(set) var itemSize: ItemSize
    public private(set) var interitemSpacing: CGFloat
    public private(set) var lineSpacing: CGFloat
    public private(set) var inset: UIEdgeInsets
    public private(set) var horizontalEdgeMode: EdgeMode
    public private(set) var verticalEdgeMode: EdgeMode
    private let cellProvider: () -> ShimmerReplicatorViewCell
    
    private var cellSizeConstraints = [UIView: [NSLayoutConstraint]]()
    
    /// Initializer
    /// - Parameters:
    ///   - itemSize: The size of each cells.
    ///   - interitemSpacing: The spacing between items in a same row.
    ///   - lineSpacing: The spacing between rows.
    ///   - inset: Inset for the contents.
    ///   - horizontalEdgeMode: The edge mode for the horizontal direction.
    ///   - verticalEdgeMode: The edge mode for the vertical direction.
    ///   - cellProvider: A closure to create an instance of `ShimmerReplicatorViewCell`.
    public init(itemSize: ItemSize, interitemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0, inset: UIEdgeInsets = .zero, horizontalEdgeMode: EdgeMode = .beyond, verticalEdgeMode: EdgeMode = .beyond, cellProvider: @escaping () -> ShimmerReplicatorViewCell) {
        self.itemSize = itemSize
        self.interitemSpacing = interitemSpacing
        self.lineSpacing = lineSpacing
        self.inset = inset
        self.horizontalEdgeMode = horizontalEdgeMode
        self.verticalEdgeMode = verticalEdgeMode
        self.cellProvider = cellProvider
        
        super.init(frame: .zero)

        addSubview(stackView)
        stackView.spacing = interitemSpacing
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left)
        ])

        if horizontalEdgeMode == .within {
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right).isActive = true
            stackView.distribution = .equalSpacing
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(itemSize: ItemSize? = nil, interitemSpacing: CGFloat? = nil, lineSpacing: CGFloat? = nil, inset: UIEdgeInsets? = nil) {
        if let itemSize = itemSize {
            self.itemSize = itemSize
        }

        if let interitemSpacing = interitemSpacing {
            self.interitemSpacing = interitemSpacing
        }

        if let lineSpacing = lineSpacing {
            self.lineSpacing = lineSpacing
        }

        if let inset = inset {
            self.inset = inset
        }

        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // calculate item size
        var itemSize: CGSize = .zero
        switch self.itemSize {
        case .fixedSize(let size):
            itemSize = size
        case .fixedHeight(let height):
            itemSize.height = height
            itemSize.width = frame.inset(by: inset).width
        }

        let frameSize = frame.inset(by: inset)
        var horizontalNumber = floor((frameSize.width + interitemSpacing)/(itemSize.width + interitemSpacing))
        if (horizontalNumber-1) * (itemSize.width + interitemSpacing) + itemSize.width < frameSize.width && horizontalEdgeMode == .beyond {
            horizontalNumber += 1
        }

        var verticalNumber = floor((frameSize.height + lineSpacing)/(itemSize.height + lineSpacing))
        if (verticalNumber-1) * (itemSize.height + lineSpacing) + itemSize.height < frameSize.height && verticalEdgeMode == .beyond {
            verticalNumber += 1
        }

        replicatorLayer.instanceCount = Int(verticalNumber)
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, itemSize.height + lineSpacing, 0)

        // Remove the previous cell constraints
        cellSizeConstraints.forEach { cell, constraints in
            constraints.forEach { constraint in
                constraint.isActive = false
                cell.removeConstraint(constraint)
            }
        }
        cellSizeConstraints.removeAll()
        
        let currentCount = stackView.arrangedSubviews.count
        // reset the cell
        for i in 0..<currentCount {
            let cell = stackView.arrangedSubviews[i]
            let widthConstraint = cell.widthAnchor.constraint(equalToConstant: itemSize.width)
            let heightConstraint = cell.heightAnchor.constraint(equalToConstant: itemSize.height)
            NSLayoutConstraint.activate([widthConstraint, heightConstraint])
            cellSizeConstraints[cell] = [widthConstraint, heightConstraint]
            if isAnimating, let cell = cell as? ShimmerReplicatorViewCell {
                cell.startAnimating()
            }
        }
        
        // add/remove cells to the stack view
        if currentCount < Int(horizontalNumber) {
            for _ in 0..<(Int(horizontalNumber)-currentCount) {
                let newCell = cellProvider()
                newCell.translatesAutoresizingMaskIntoConstraints = false
                let widthConstraint = newCell.widthAnchor.constraint(equalToConstant: itemSize.width)
                let heightConstraint = newCell.heightAnchor.constraint(equalToConstant: itemSize.height)
                NSLayoutConstraint.activate([widthConstraint, heightConstraint])
                cellSizeConstraints[newCell] = [widthConstraint, heightConstraint]
                stackView.addArrangedSubview(newCell)
                if isAnimating {
                    newCell.startAnimating()
                }
            }
        } else if currentCount > Int(horizontalNumber) {
            for _ in 0..<(currentCount-Int(horizontalNumber)) {
                if let lastView = stackView.arrangedSubviews.last {
                    lastView.removeFromSuperview()
                }
            }
        }
    }

    public func startAnimating() {
        isAnimating = true
        stackView.arrangedSubviews.compactMap { $0 as? ShimmerReplicatorViewCell }.forEach {
            $0.startAnimating()
        }
    }
    
    public func stopAnimating() {
        isAnimating = false
        stackView.arrangedSubviews.compactMap { $0 as? ShimmerReplicatorViewCell }.forEach {
            $0.stopAnimating()
        }
    }
}
