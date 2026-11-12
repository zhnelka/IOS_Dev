
import UIKit

let books: [TableItem] = [
    TableItem(title: "Как закалялась сталь",
              subtitle: "by Nikolai Ostrovsky",
              review: "A novel about Pavel Korchagin, who overcomes personal and social hardships, strengthens his character, and learns resilience in the face of life’s challenges.",
              image: #imageLiteral(resourceName: "book1"),
              category: .book),
    
    TableItem(title: "Martin Eden",
              subtitle: "by Jack London",
              review: "A novel about a young sailor striving for self-improvement and literary success, confronting love, society, and personal ambitions.",
              image: #imageLiteral(resourceName: "book2"),
              category: .book),
    
    TableItem(title: "Воскресение",
              subtitle: "by Лев Толстой",
              review: "A story about a person seeking to atone for past mistakes and achieve spiritual redemption.",
              image: #imageLiteral(resourceName: "book3"),
              category: .book),
    
    TableItem(title: "The Suicide Club",
              subtitle: "by Robert Louis Stevenson",
              review: "A collection of stories about a secret society where those wishing to die enter a risky pact that leads to unexpected consequences.",
              image: #imageLiteral(resourceName: "book4"),
              category: .book),
    
    TableItem(title: "Белый пароход",
              subtitle: "by Чингиз Айтматов",
              review: "A story about a boy, his dreams of a white steamship, and his encounter with adult cruelty.",
              image: #imageLiteral(resourceName: "book5"),
              category: .book),
    
    TableItem(title: "Униженные и оскорблённые",
              subtitle: "by Фёдор Достоевский",
              review: "A poem about people who have been victims of betrayal, poverty and cruelty, and how they maintain love, kindness and dignity despite pain and injustice.",
              image: #imageLiteral(resourceName: "book6"),
              category: .book),
        
    TableItem(title: "1984",
              subtitle: "by George Orwell",
              review: "A novel about a totalitarian society where the authorities completely control the thoughts and lives of people, and the hero tries to preserve freedom and truth in a world of total surveillance and lies.",
              image: #imageLiteral(resourceName: "book7"),
              category: .book),
        
    TableItem(title: "The Great Gatsby",
              subtitle: "by F. Scott Fitzgerald",
              review: "A novel about wealth, dreams, and illusions, Jay Gatsby tries to win back his lost love by creating a glittering but empty world of luxury that ultimately leads to tragedy.",
              image: #imageLiteral(resourceName: "book8"),
              category: .book),
        
    TableItem(title: "The Metamorphosis",
              subtitle: "by Franz Kafka",
              review: "The story of a man who wakes up one day transformed into an insect, and through this transformation, his alienation, loneliness, and the gradual destruction of his connection to his family and community are revealed.",
              image: #imageLiteral(resourceName: "book9"),
              category: .book),
        
    TableItem(title: "The Elephant Vanishes",
              subtitle: "by Haruki Murakami",
              review: "Murakami's story of a circus elephant who mysteriously disappears, leaving the protagonist with a feeling of strangeness and loss, as if reality had cracked.",
              image: #imageLiteral(resourceName: "book10"),
              category: .book)
    ]


class BookViewController: ViewController {

    override var items: [TableItem] {
            return books
    }
    
    override func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookTableViewCell
        let currentBook = books[indexPath.row]
        cell.configure(book: currentBook)
        return cell
    }
    
    override func getSelectedItem(indexPath: IndexPath) -> TableItem? {
        return books[indexPath.row]
    }
}

