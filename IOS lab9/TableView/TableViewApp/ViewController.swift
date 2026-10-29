import UIKit



enum Category : String, CaseIterable {
    case movie = "Movie"
    case audio = "Audio"
    case book = "Book"
    case course = "Course"
}
struct TableItem {
    let title: String
    let subtitle: String
    let review: String
    let image: UIImage
    let category : Category
}

class ViewController: UIViewController, UITableViewDelegate {
    let movies: [TableItem] = [
        TableItem(title: "Avengers: Endgame",
                  subtitle: "by Anthony & Joe Russo",
                  review: "The surviving heroes make one final attempt to undo Thanos’ devastation, leading to an emotional and epic showdown that ties together a decade of Marvel storytelling.",
                  image: #imageLiteral(resourceName: "movie1"),
                  category: .movie),
        
        TableItem(title: "Greenland",
                  subtitle: "by Ric Roman Waugh",
                  review: "As a catastrophic comet races toward Earth, a fractured family fights for survival, revealing both the fragility of society and the fierce power of human desperation.",
                  image: #imageLiteral(resourceName: "movie2"),
                  category: .movie),
        
        TableItem(title: "Avatar",
                  subtitle: "by James Cameron",
                  review: "A wounded marine sent to the lush moon of Pandora becomes torn between duty and a new way of life, in a visually stunning story of conflict, identity, and connection with nature.",
                  image: #imageLiteral(resourceName: "movie3"),
                  category: .movie),
        
        TableItem(title: "Parasite",
                  subtitle: "by Bong Joon-ho",
                  review: "A poor family infiltrates the life of a wealthy household, but their clever scheme spirals into a dark, gripping exploration of class, deception, and consequences.",
                  image: #imageLiteral(resourceName: "movie4"),
                  category: .movie),
        
        TableItem(title: "Jumanji: Welcome to the Jungle",
                  subtitle: "by Jake Kasdan",
                  review: "Four teenagers are pulled into a video-game world where they must survive dangerous levels and work together, discovering courage and identity in a hilarious, high-stakes adventure.",
                  image: #imageLiteral(resourceName: "movie5"),
                  category: .movie)
    ]
    
    let audios: [TableItem] = [
        TableItem(title: "Feel It",
                  subtitle: "by d4vd",
                  review: "An emotional outpouring wrapped in gentle vocals, capturing the ache of longing and the fear of losing someone, delivered through atmospheric production that amplifies the vulnerability.",
                  image: #imageLiteral(resourceName: "track1"),
                  category: .audio),
        
        TableItem(title: "like JENNIE",
                  subtitle: "by JENNIE",
                  review: "A confident, stylish anthem where JENNIE blends sleek pop energy with attitude, celebrating self-expression and independence with a sound as bold as her persona.",
                  image: #imageLiteral(resourceName: "track2"),
                  category: .audio),
        
        TableItem(title: "FE!N",
                  subtitle: "by Travis Scott",
                  review: "A high-octane, chaotic surge of energy, driven by hypnotic production and relentless flow, creating an explosive track that embodies obsession, adrenaline, and raw intensity.",
                  image: #imageLiteral(resourceName: "track3"),
                  category: .audio),
        
        TableItem(title: "Feel Good Inc.",
                  subtitle: "by Gorillaz",
                  review: "A genre-bending classic that contrasts dark, cynical commentary with infectious grooves, using haunting laughs and smooth melodies to paint a picture of a world chasing empty pleasures.",
                  image: #imageLiteral(resourceName: "track4"),
                  category: .audio),
        
        TableItem(title: "Too Many Nights",
                  subtitle: "by Metro Boomin",
                  review: "A moody, melodic reflection on success, excess, and emotional disconnect, blending polished production with hypnotic vocals that drift between confidence and introspection.",
                  image: #imageLiteral(resourceName: "track5"),
                  category: .audio)
    ]

    let books: [TableItem] = [
        TableItem(title: "1984",
                  subtitle: "by George Orwell",
                  review: "A chilling exploration of totalitarian control and the suppression of individuality, where Orwell exposes the fragility of truth and the terrifying power of surveillance woven into everyday life.",
                  image: #imageLiteral(resourceName: "book1"),
                  category: .book),
        
        TableItem(title: "The Great Gatsby",
                  subtitle: "by F. Scott Fitzgerald",
                  review: "A lyrical portrait of ambition, desire, and illusion, following Gatsby’s pursuit of an unattainable dream against the glittering yet hollow backdrop of the Roaring Twenties.",
                  image: #imageLiteral(resourceName: "book2"),
                  category: .book),
        
        TableItem(title: "To Kill a Mockingbird",
                  subtitle: "by Harper Lee",
                  review: "A powerful, compassionate story about moral courage and racial injustice, seen through a child’s innocent lens as she witnesses the complexities of human nature in a divided town.",
                  image: #imageLiteral(resourceName: "book3"),
                  category: .book),
        
        TableItem(title: "The Alchemist",
                  subtitle: "by Paulo Coelho",
                  review: "A poetic journey of self-discovery, where Santiago follows omens and dreams across the desert, learning that purpose and treasure are often found within the seeker himself.",
                  image: #imageLiteral(resourceName: "book4"),
                  category: .book),
        
        TableItem(title: "Harry Potter and the Sorcerer’s Stone",
                  subtitle: "by J.K. Rowling",
                  review: "A magical introduction to a world of wonder and danger, where a lonely boy discovers friendship, destiny, and the courage to face darkness for the first time.",
                  image: #imageLiteral(resourceName: "book5"),
                  category: .book)
    ]
    
    let courses: [TableItem] = [
        TableItem(title: "iOS Development",
                  subtitle: "Teacher: Zhakhan A.",
                  review: "A hands-on journey into building modern mobile apps, guiding learners through Swift, UIKit, and real-world interface design while turning creative ideas into polished, functional iOS experiences.",
                  image: #imageLiteral(resourceName: "course1"),
                  category: .course),
        
        TableItem(title: "Calculus",
                  subtitle: "Teacher: Askarbekkyzy A.",
                  review: "A deep exploration of change, motion, and growth, where limits, derivatives, and integrals reveal the hidden structure of the physical world and the elegant logic behind continuous systems.",
                  image: #imageLiteral(resourceName: "course2"),
                  category: .course),
        
        TableItem(title: "Web Development",
                  subtitle: "Teacher: Izbassar A.",
                  review: "An immersive dive into front-end and back-end creation, blending HTML, CSS, JavaScript, and server technologies to teach how dynamic, responsive websites come to life from scratch.",
                  image: #imageLiteral(resourceName: "course3"),
                  category: .course),
        
        TableItem(title: "Computer Architecture",
                  subtitle: "Teacher: Yoldash S.",
                  review: "A detailed look under the hood of computing machines, uncovering how processors, memory, and instruction cycles interact to transform simple binary operations into powerful digital intelligence.",
                  image: #imageLiteral(resourceName: "course4"),
                  category: .course),
        
        TableItem(title: "Software Engineering",
                  subtitle: "Teacher: Aldamuratov Z.",
                  review: "A structured study of building reliable, scalable systems, focusing on design patterns, teamwork, testing, and lifecycle models that turn complex ideas into maintainable software solutions.",
                  image: #imageLiteral(resourceName: "course5"),
                  category: .course)
    ]



    @IBOutlet private weak var table : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    }


}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = Category.allCases[section]
        switch currentSection {
            case .movie: return movies.count
            case .audio: return audios.count
            case .book: return books.count
            case .course: return courses.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = Category.allCases[section]
        return category.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSection = Category.allCases[indexPath.section]
        
        switch(currentSection){
        case .movie:
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
            let currentMovie = movies[indexPath.row]
            cell.configure(movie: currentMovie)
            return cell
        case .audio:
            let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! AudioTableViewCell
            let currentAudio = audios[indexPath.row]
            cell.configure(audio: currentAudio)
            return cell
        case .book:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookTableViewCell
            let currentBook = books[indexPath.row]
            cell.configure(book: currentBook)
            return cell
        case .course:
            let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! CourseTableViewCell
            let currentCourse = courses[indexPath.row]
            cell.configure(course: currentCourse)
            return cell
        }
    }

}
