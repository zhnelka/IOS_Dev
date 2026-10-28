import UIKit

struct Sneakers {
    let name: String
    let image: String
}

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var Label: UILabel!
    
    let items: [Sneakers] = [
        Sneakers(name: "Nike Air Max", image: "airmax"),
        Sneakers(name: "New Balance 2002", image: "balance"),
        Sneakers(name: "Crocs", image: "crocs"),
        Sneakers(name: "Nike Dunk", image: "dunk"),
        Sneakers(name: "Nike Air Jordan 1", image: "jordan 1"),
        Sneakers(name: "Adidas Niteball", image: "niteball"),
        Sneakers(name: "Adidas Ozelia", image: "ozelia"),
        Sneakers(name: "Adidas Samba", image: "samba"),
        Sneakers(name: "Puma Speedcat", image: "speedcat"),
        Sneakers(name: "Nike Vapor Max", image: "vapormax")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomizeTapped(self)
        randomizeButton.layer.cornerRadius = 18
        randomizeButton.layer.borderWidth = 1.5
    }
    
    
    @IBAction func randomizeTapped(_ sender: Any) {
        let randomItem = items.randomElement()!
        image.image = UIImage(named: randomItem.image)
        titleLabel.text = randomItem.name
    }
}

