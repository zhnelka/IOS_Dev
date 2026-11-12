
import UIKit


let courses: [TableItem] = [
    TableItem(title: "Golang Application Development",
              subtitle: "Lecturer: Zhanshuakov A.K.",
              review: "Developing applications in Go, learning syntax, standard library, and building server-side solutions.",
              image: #imageLiteral(resourceName: "course1"),
              category: .course),
    
    TableItem(title: "Blockchain Technologies and Applications",
              subtitle: "Lecturer: Aasso Ziro",
              review: "Study of blockchain technologies, their principles, and practical use in cryptocurrencies and smart contracts.",
              image: #imageLiteral(resourceName: "course2"),
              category: .course),
    
    TableItem(title: "iOS Development",
              subtitle: "Lecturer: Arman Myrzakanurov",
              review: "Creating mobile apps for iOS, learning Swift, Xcode.",
              image: #imageLiteral(resourceName: "course3"),
              category: .course),
    
    TableItem(title: "Statistics",
              subtitle: "Lecturer: Mukash N.K.",
              review: "Basics of statistics, data analysis methods, probabilities, and interpreting results.",
              image: #imageLiteral(resourceName: "course4"),
              category: .course),
    
    TableItem(title: "Object-Oriented Programming",
              subtitle: "Lecturer: Pakizar Shamoi",
              review: "Study of the object-oriented approach: classes, objects, inheritance, encapsulation, and polymorphism for building programs.",
              image: #imageLiteral(resourceName: "course5"),
              category: .course),

    TableItem(title: "Algorithms and data structures",
              subtitle: "Lecturer: Aman J.",
              review: "Efficient problem solving using optimal data structures and key algorithms, analyzing their performance.",
              image: #imageLiteral(resourceName: "course6"),
              category: .course),
        
    TableItem(title: "Security of operating systems",
              subtitle: "Lecturer: Denis Valyaev",
              review: "Studies methods of protecting operating systems from vulnerabilities, attacks and unauthorized access.",
              image: #imageLiteral(resourceName: "course7"),
              category: .course),
        
    TableItem(title: "Ethical hacking",
              subtitle: "Lecturer: Aasso Ziro",
              review: "Teaches methods for detecting and preventing cyberattacks, using the same techniques as hackers, but for legal and defensive purposes.",
              image: #imageLiteral(resourceName: "course8"),
              category: .course),
        
    TableItem(title: "Discrete structures",
              subtitle: "Lecturer: Ulzhan Ostemirova",
              review: "Mathematical structures such as sets, graphs, logic, and combinatorics that underlie computer science.",
              image: #imageLiteral(resourceName: "course9"),
              category: .course),
        
    TableItem(title: "Modern methods of software development",
              subtitle: "Lecturer: Aron Karataev",
              review: "Modern approaches and practices of software development, including Agile, DevOps, CI/CD and flexible project management methodologies.",
              image: #imageLiteral(resourceName: "course10"),
              category: .course)
]




class CourseViewController: ViewController {

    override var items: [TableItem] {
            return courses
    }
    
    override func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! CourseTableViewCell
        let currentCourse = courses[indexPath.row]
        cell.configure(course: currentCourse)
        return cell
    }
    
    override func getSelectedItem(indexPath: IndexPath) -> TableItem? {
        return courses[indexPath.row]
    }
}

