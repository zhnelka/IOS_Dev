
import UIKit

let audios: [TableItem] = [
    TableItem(title: "Танцуй",
              subtitle: "by Масло Черного Тмина",
              review: "A humorous, absurd, energetic composition with an Eastern vibe that mixes a dance beat and meme-worthy lyrics for a cheerful mood.",
              image: #imageLiteral(resourceName: "track1"),
              category: .audio),
    
    TableItem(title: "Незаметно",
              subtitle: "by Масло Черного Тмина",
              review: "A soft, atmospheric composition about how feelings or changes come quietly and gradually, leaving a deep mark.",
              image: #imageLiteral(resourceName: "track2"),
              category: .audio),
    
    TableItem(title: "Любовь HD1080",
              subtitle: "by Каспийский Груз",
              review: "A dark, cinematic tale of a toxic relationship, told in the duo's signature style: cold honesty, an atmospheric beat, and metaphors that cut more sharply than HD.",
              image: #imageLiteral(resourceName: "track3"),
              category: .audio),
    
    TableItem(title: "Beautiful",
              subtitle: "by Eminem",
              review: "A heartfelt, painfully honest confession about battling inner demons, where he reminds himself and the listener through a melancholy beat and powerful lyrics that human worth never fades, even when the world seems hostile.",
              image: #imageLiteral(resourceName: "track4"),
              category: .audio),
    
    TableItem(title: "Type Shit",
              subtitle: "by Future, Metro Boomin, Travis Scott, Playboi Carti",
              review: "A hard-hitting, self-assured trap banger where the artists deliver their signature flow, boast about their skill level, and sound like they're setting a standard—we only make this type of shit.",
              image: #imageLiteral(resourceName: "track5"),
              category: .audio),
    
    TableItem(title: "PIXELATED KISSES",
              subtitle: "by Joji",
              review: "A soft, dreamy and slightly sad song about love that feels distant and dissolving, like pixels on a screen.",
              image: #imageLiteral(resourceName: "track6"),
              category: .audio),
        
    TableItem(title: "Hoodrich Tales",
              subtitle: "by Big Baby Tape",
              review: "The legendary album that launched the Big Baby Tape's fame.",
              image: #imageLiteral(resourceName: "track7"),
              category: .audio),
        
    TableItem(title: "FLUDDALITY",
              subtitle: "by GONE.Fludd",
              review: "Just a good mumble rap album.",
              image: #imageLiteral(resourceName: "track8"),
              category: .audio),
        
    TableItem(title: "PRIDE.",
              subtitle: "by Kendrick Lamar",
              review: "An emotional, reflective song about struggling with pride, regret, and complicated feelings in relationships.",
              image: #imageLiteral(resourceName: "track9"),
              category: .audio),
        
    TableItem(title: "Trust",
              subtitle: "by Brent Faiyaz",
              review: "A sensual and melancholic song about the need for trust and vulnerability in love.",
              image: #imageLiteral(resourceName: "track10"),
              category: .audio)
    ]



class AudioViewController: ViewController {

    override var items: [TableItem] {
            return audios
    }
    
    override func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! AudioTableViewCell
        let currentAudio = audios[indexPath.row]
        cell.configure(audio: currentAudio)
        return cell
    }
    
    override func getSelectedItem(indexPath: IndexPath) -> TableItem? {
        return audios[indexPath.row]
    }
    
}

