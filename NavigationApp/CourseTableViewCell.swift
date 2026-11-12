
import UIKit

class CourseTableViewCell: UITableViewCell {
    @IBOutlet weak var courseCover: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseLecturer: UILabel!
    @IBOutlet weak var courseReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(course: TableItem) {
        if(course.category != Category.course){
            return
        }
        courseTitle.text = course.title
        courseLecturer.text = course.subtitle
        courseReview.text = course.review
        courseCover.image = course.image
    }


}
