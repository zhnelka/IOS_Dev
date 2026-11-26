import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var durability: UILabel!
    @IBOutlet weak var power: UILabel!
    @IBOutlet weak var combat: UILabel!
    @IBOutlet weak var intelligence: UILabel!
    @IBOutlet weak var strength: UILabel!
    
    let blurredBackground = UIImageView()
    let service = HeroesService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurredBackground.frame = view.bounds
        blurredBackground.contentMode = .scaleAspectFill
        blurredBackground.clipsToBounds = true
        view.insertSubview(blurredBackground, at: 0)
        
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackground.addSubview(blurView)
        
        // Закругления картинки
        heroImage.layer.cornerRadius = 20
        heroImage.clipsToBounds = true
                
        // Feature: restore last saved hero on app launch
        if let savedHero = loadSavedHero() {
            configureHero(hero: savedHero)
        }
    }
    
    // Feature: save hero to UserDefaults
    func saveHero(_ hero: HeroModel) {
        guard let data = try? PropertyListEncoder().encode(hero) else { return }
        UserDefaults.standard.set(data, forKey: "lastHero")
    }

        // Feature: load hero from UserDefaults
    func loadSavedHero() -> HeroModel? {
        guard
            let data = UserDefaults.standard.data(forKey: "lastHero"),
            let hero = try? PropertyListDecoder().decode(HeroModel.self, from: data)
        else { return nil }
            
        return hero
    }
    
    func configureHero(hero : HeroModel){
        heroName.text = "\(hero.name) \(hero.appearance.gender=="Male" ?  "♂" : (hero.appearance.gender == "Female" ? "♀": "⚲" ))"
        weight.text = hero.appearance.weight[1]
        height.text = hero.appearance.height[1]
        speed.text = "\(hero.powerstats.speed)"
        durability.text = "\(hero.powerstats.durability)"
        power.text = "\(hero.powerstats.power)"
        combat.text = "\(hero.powerstats.combat)"
        intelligence.text = "\(hero.powerstats.intelligence)"
        strength.text = "\(hero.powerstats.strength)"
        heroImage.kf.setImage(with: URL(string: hero.images.lg))
        
        if let url = URL(string: hero.images.lg) {
                    heroImage.kf.setImage(with: url)
                    // Заполняем фон тем же изображением (Kingfisher подставит и кэширует)
                    blurredBackground.kf.setImage(with: url)
                } else {
                    heroImage.image = nil
                    blurredBackground.image = nil
                }
        
    }


@IBAction func didRoll(_ sender: Any){
        Task { @MainActor in
            var hero: HeroModel? = nil
            repeat {
                let randomId = Int.random(in: 1...731)
                do {
                    hero = try await service.fetchHero(id: randomId)
                } catch {
                    if let urlError = error as? URLError {
                        print("Error: \(urlError)")
                    }
                    continue
                }
                
            } while hero == nil
        
            UIView.animate(withDuration: 0.3, animations: {
                            self.heroImage.alpha = 0
                            self.heroName.alpha = 0
                            self.weight.alpha = 0
                            self.height.alpha = 0
                            self.speed.alpha = 0
                            self.durability.alpha = 0
                            self.power.alpha = 0
                            self.combat.alpha = 0
                            self.intelligence.alpha = 0
                            self.strength.alpha = 0
                        }) { _ in
                            // Обновляем данные после исчезновения
                            self.configureHero(hero: hero!)
                            
                            // Feature: save hero after roll
                            self.saveHero(hero!)
                            
                            // ------------------------- ANIMATION END (fade-in) -------------------------
                            UIView.animate(withDuration: 0.3) {
                                self.heroImage.alpha = 1
                                self.heroName.alpha = 1
                                self.weight.alpha = 1
                                self.height.alpha = 1
                                self.speed.alpha = 1
                                self.durability.alpha = 1
                                self.power.alpha = 1
                                self.combat.alpha = 1
                                self.intelligence.alpha = 1
                                self.strength.alpha = 1
                            }
                        }
        }
    }
    
}
