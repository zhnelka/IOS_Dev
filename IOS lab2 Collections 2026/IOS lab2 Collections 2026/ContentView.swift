import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        let fruits = ["Apple", "Banan", "Orange", "Mango", "Grape"]
        print(fruits[2])
        
        var numbers: Set = [2, 5, 8]
        numbers.insert(10)
        print(numbers)
        
        let languages = [
            "Swift": 2014,
            "C++": 1991,
            "1C": 1995
        ]
        print(languages["Swift"]!)
        
        var colors = ["Red", "Blue", "Green", "Black"]
        colors[1] = "Pikmi"
        print(colors)
        
        let set1: Set = [1, 2, 3, 4]
        let set2: Set = [3, 4, 5, 6]
        print(set1.intersection(set2))
        
        var students = [
            "Aruzhan": 80,
            "Batyrkhan": 90,
            "Sabina": 75
        ]
        students.updateValue(95, forKey: "Batyrkhan")
        print(students)
        
        var first = ["apple", "banan"]
        let second = ["cherry", "date"]
        first.append(contentsOf: second)
        print(first)
        
        var countries = [
            "Kazakhstan": 777_777_777,
            "USA": 500_000_000,
            "Japan": 123_000_000
        ]
        countries["China"] = 1_400_000_000
        print(countries)
        
        let animals1: Set = ["cat", "dog"]
        let animals2: Set = ["dog", "mouse"]
        let animals = animals1.union(animals2)
        print(animals.subtracting(animals2))
        
        let grades = [
            "Aruzhan": [90, 85, 88],
            "Batyrkhan": [77, 77, 77],
            "Sabina": [95, 89, 91]
        ]
        print(grades["Aruzhan"]![1])
        
        return Text("Boldy bitti")
    }
}
