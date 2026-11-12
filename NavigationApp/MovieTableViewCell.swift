
import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieCover: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDirector: UILabel!
    
    @IBOutlet weak var movieReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(movie: TableItem) {
        if(movie.category != Category.movie){
            return
        }
        movieTitle.text = movie.title
        movieDirector.text = movie.subtitle
        movieReview.text = movie.review
        movieCover.image = movie.image
    }

}
