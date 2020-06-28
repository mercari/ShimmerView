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
        
        firstLineView.layer.cornerRadius = firstLineView.frame.height/2
        firstLineView.layer.masksToBounds = true
        
        secondLineView.layer.cornerRadius = secondLineView.frame.height/2
        secondLineView.layer.masksToBounds = true
        
        thirdLineView.layer.cornerRadius = thirdLineView.frame.height/2
        thirdLineView.layer.masksToBounds = true
    }
    
    func startAnimating() {
        thumbnailView.startAnimating()
        firstLineView.startAnimating()
        secondLineView.startAnimating()
        thirdLineView.startAnimating()
    }
}
