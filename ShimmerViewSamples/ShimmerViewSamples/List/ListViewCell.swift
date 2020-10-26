import UIKit
import ShimmerView

class ListViewCell: UIView, ShimmerReplicatorViewCell {
    @IBOutlet weak var thumbnailView: ShimmerView!
    @IBOutlet weak var firstLineView: ShimmerView!
    @IBOutlet weak var secondLineView: ShimmerView!
    @IBOutlet weak var thirdLineView: ShimmerView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func startAnimating() {
        thumbnailView.startAnimating()
        firstLineView.startAnimating()
        secondLineView.startAnimating()
        thirdLineView.startAnimating()
    }
    
    func stopAnimating() {
        thumbnailView.stopAnimating()
        firstLineView.stopAnimating()
        secondLineView.stopAnimating()
        thirdLineView.stopAnimating()
    }
}
