
import UIKit

class AudioTableViewCell: UITableViewCell {
    @IBOutlet weak var audioCover: UIImageView!
    
    @IBOutlet weak var audioName: UILabel!
    
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(audio: TableItem) {
        if(audio.category != Category.audio){
            return
        }
        audioName.text = audio.title
        artistLabel.text = audio.subtitle
        review.text = audio.review
        audioCover.image = audio.image
    }

}
