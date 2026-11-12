
import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var bookCover: UIImageView!
    
    @IBOutlet weak var bookAuthor: UILabel!
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(book: TableItem) {
        if(book.category != Category.book){
            return
        }
        bookTitle.text = book.title
        bookAuthor.text = book.subtitle
        bookReview.text = book.review
        bookCover.image = book.image
    }

}
