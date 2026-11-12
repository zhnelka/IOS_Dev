
import UIKit

let movies: [TableItem] = [
    TableItem(title: "Contratiempo",
              subtitle: "by Oriol Paulo",
              review: "A successful businessman, accused of murdering his mistress, tries to prove his innocence, but every new detail makes the story more and more unexpected.",
              image: #imageLiteral(resourceName: "movie1"),
              category: .movie),
    
    TableItem(title: "Ауру",
              subtitle: "by Aitore Zholdaskali",
              review: "A young family, deeply in debt, fakes the wife's illness to earn money for her 'treatment', but their lies spiral out of control, leading to tragic consequences.",
              image: #imageLiteral(resourceName: "movie2"),
              category: .movie),
    
    TableItem(title: "Tenet",
              subtitle: "by Christopher Nolan",
              review: "A spy thriller about a secret agent who uses time-reversal technology to prevent a global catastrophe, encountering inversion effects and temporal paradoxes.",
              image: #imageLiteral(resourceName: "movie3"),
              category: .movie),
    
    TableItem(title: "Interstellar",
              subtitle: "by Christopher Nolan",
              review: "A group of astronauts travel through a wormhole in search of a new planet for humanity, facing challenges of time, gravity, and emotional trials that test the limits of human love and endurance.",
              image: #imageLiteral(resourceName: "movie4"),
              category: .movie),
    
    TableItem(title: "Hacksaw Ridge",
              subtitle: "by Mel Gibson",
              review: "The story of Desmond Doss, a Jehovah's Witness soldier who refuses to bear arms in World War II but displays incredible bravery, saving the lives of hundreds of soldiers during the bloody Battle of Okinawa.",
              image: #imageLiteral(resourceName: "movie5"),
              category: .movie),
        
    TableItem(title: "Inception",
                subtitle: "by Christopher Nolan",
                review: "A film about a team of specialists who enter people's dreams to plant or steal ideas, colliding with the boundary between reality and the subconscious.",
                image: #imageLiteral(resourceName: "movie6"),
                category: .movie),
        
    TableItem(title: "Source Code",
                subtitle: "by Duncan Jones",
                review: "An intense thriller about a man who relives the same eight minutes to solve a terrorist attack and understand his own reality.",
                image: #imageLiteral(resourceName: "movie7"),
                category: .movie),
        
    TableItem(title: "The Imitation Game",
                subtitle: "by Morten Tyldum",
                review: "English mathematician and logician Alan Turing attempts to crack the German Enigma encryption machine during World War II.",
                image: #imageLiteral(resourceName: "movie8"),
                category: .movie),
        
    TableItem(title: "Kingsman: The Secret Service",
                subtitle: "by Matthew Vaughn",
                review: "A stylish and daring spy thriller about a rookie who undergoes rigorous training to become an agent for an elite secret organization.",
                image: #imageLiteral(resourceName: "movie9"),
                category: .movie),
    
    TableItem(title: "Ready Player One",
                subtitle: "by Steven Spielberg",
                review: "A vibrant and dynamic adventure about a young man who dives into a virtual world to complete a deadly game and change the future.",
                image: #imageLiteral(resourceName: "movie10"),
                category: .movie)
    ]

class MovieViewController: ViewController {

    override var items: [TableItem] {
            return movies
    }
    
    override func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
        let currentMovie = movies[indexPath.row]
        cell.configure(movie: currentMovie)
        return cell
    }
    
    override func getSelectedItem(indexPath: IndexPath) -> TableItem? {
        return movies[indexPath.row]
    }
}

