import UIKit

public protocol ShimmerReplicatorViewCell: UIView {
    associatedtype Input
    init(with input: Input)
    func startAnimating()
}

extension ShimmerReplicatorViewCell where Input == Void {
    public init(with input: Input) {
        self.init(frame: .zero)
    }
}

public class ShimmerReplicatorView<Cell: ShimmerReplicatorViewCell>: UIView {

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

    private let cellInput: Cell.Input
    public private(set) var itemSize: ItemSize
    public private(set) var interitemSpacing: CGFloat
    public private(set) var lineSpacing: CGFloat
    public private(set) var inset: UIEdgeInsets
    public private(set) var horizontalEdgeMode: EdgeMode
    public private(set) var verticalEdgeMode: EdgeMode

    public init(cellInput: Cell.Input, itemSize: ItemSize, interitemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0, inset: UIEdgeInsets = .zero, horizontalEdgeMode: EdgeMode = .beyond, verticalEdgeMode: EdgeMode = .beyond) {
        self.cellInput = cellInput
        self.itemSize = itemSize
        self.interitemSpacing = interitemSpacing
        self.lineSpacing = lineSpacing
        self.inset = inset
        self.horizontalEdgeMode = horizontalEdgeMode
        self.verticalEdgeMode = verticalEdgeMode

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

        // add/remove cells to the stack view
        let currentCount = stackView.arrangedSubviews.count
        if currentCount < Int(horizontalNumber) {
            for _ in 0..<(Int(horizontalNumber)-currentCount) {
                let newCell = Cell(with: cellInput)
                newCell.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    newCell.widthAnchor.constraint(equalToConstant: itemSize.width),
                    newCell.heightAnchor.constraint(equalToConstant: itemSize.height)
                ])
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
        stackView.arrangedSubviews.compactMap { $0 as? Cell }.forEach {
            $0.startAnimating()
        }
    }
}

extension ShimmerReplicatorView where Cell.Input == Void {
    public convenience init(itemSize: ItemSize, interitemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0, inset: UIEdgeInsets = .zero) {
        self.init(cellInput: (), itemSize: itemSize, interitemSpacing: interitemSpacing, lineSpacing: lineSpacing, inset: inset)
    }
}
