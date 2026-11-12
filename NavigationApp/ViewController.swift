
import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var table : UITableView!
    
    var items: [TableItem] { [] }
    
    var selectedItem : TableItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedItem = getSelectedItem(indexPath: indexPath)
            performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    func getCell(tableView: UITableView, indexPath : IndexPath) ->  UITableViewCell {
        return UITableViewCell()
    }
    
    func getSelectedItem(indexPath : IndexPath) -> TableItem? {
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails",
                   let destination = segue.destination as? DetailViewController {
                    destination.item = selectedItem
                }
    }

}



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
    
