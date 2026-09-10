import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        let firstName = "Zhanel"
        let lastName = "Azimbay"
        let age = 20
        let birthYear = 2006
        let isStudent = true
        let height = 1.60
        
        let currentYear = 2026
        let calculatedAge = currentYear - birthYear
        
        let country = "Kazakhstan"
        let city = "Almaty"
        
        let hobby = "reading"
        let numberOfHobbies = 4
        let favoriteNumber = 21
        let isHobbyCreative = false
        
        let favoriteFood = "miso soup"
        let favoriteColor = "brown"
        
        let futureGoals = "In the future, I want to become... idk i just wanna be happy and not worry about anything"
        
        let lifeStory = """
        My name is \(firstName) \(lastName).
        I am \(calculatedAge) years old and I was born in \(birthYear).
        I am currently a student: \(isStudent).
        I live in \(city), \(country).
        My height is \(height) meters.
        I enjoy \(hobby).
        I have \(numberOfHobbies) hobbies in total.
        My favorite number is \(favoriteNumber).
        My favorite food is \(favoriteFood).
        My favorite color is \(favoriteColor).
        \(futureGoals)
        """
        
        print(lifeStory)
        
        return Text(lifeStory)
            .padding()
    }
}
