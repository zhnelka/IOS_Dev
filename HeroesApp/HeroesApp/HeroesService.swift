
import Foundation

struct HeroesService {
    func fetchHero(id: Int) async throws -> HeroModel{
        let urlString = "https://akabab.github.io/superhero-api/api/id/\(id).json"
        guard let url = URL(string : urlString) else{
            throw ServiceError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(data, response)
        let decoded = try JSONDecoder().decode(HeroModel.self, from: data)
        return decoded
    }
}

enum ServiceError : Error{
    case invalidURL
}
