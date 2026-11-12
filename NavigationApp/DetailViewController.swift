
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var reviewDescription: UILabel!
    
    var item: TableItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            configureInfo(item: item!)
        }
    }
    
    
    func configureInfo(item: TableItem){
        mainTitle.text = item.title
        subTitle.text = item.subtitle
        reviewDescription.text = item.review
        coverImage.image = item.image
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
