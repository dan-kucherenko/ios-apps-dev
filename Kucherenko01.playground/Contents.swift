import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct Collection {
    let no: Int
    let size: Int
    let array: [String]
}

struct CollectionsGen {
    var randomWords = [
        "Blossom","Blossom","Blossom", "Labyrinth","Nimbus",
        "Placid", "Mellifluous", "Labyrinth", "Placid",
        "Whimsical","Blossom","Nebula", "Labyrinth", "Placid", "Mellifluous",
        "Nebulous", "Labyrinth", "Juxtapose", "Mellifluous",
        "Mellifluous", "Mellifluous", "Nebula", "Nebula", "Mellifluous"
    ]
    
    var collections: [Collection] = []
    let initialSize = 24
    
    mutating private func generateCollection() {
        let randomSize = Int.random(in: initialSize/2..<initialSize)
        self.randomWords = (randomWords.prefix(randomSize) + randomWords).shuffled()
    }
    
    mutating func populateCollections() {
        for i in 1...7 {
            generateCollection()
            collections.append(Collection(no: i, size: randomWords.count, array: randomWords))
        }
    }
}

struct WordCounter {
    func countWordsSimple(in collection: [String]) -> Double {
        let start = DispatchTime.now()
        let countDictionary = collection.reduce(into: [:]) { counts, word in
            counts[word, default: 0] += 1
        }
        let end = DispatchTime.now()
        let time = end.uptimeNanoseconds - start.uptimeNanoseconds
        return Double(time) / 1_000_000 // cast to ms
    }
    
    func countWordsGcd(in collection: [String]) -> Double {
        var countDictionary: [String : Int] = [:]
        
        let queue = DispatchQueue(label: "ua.kma.kucherenko.wordcount", attributes: .concurrent)
        let group = DispatchGroup()
        
        let start = DispatchTime.now()
        collection.forEach { word in
            let wordCountIncrement = DispatchWorkItem {
                // increment number for word in dictionary
                countDictionary[word, default: 0] += 1
            }
            group.enter()
            queue.async(execute: wordCountIncrement)
            group.leave()
        }
        let end = DispatchTime.now()
        let time = end.uptimeNanoseconds - start.uptimeNanoseconds
        return Double(time) / 1_000_000 // cast to ms
    }
}



func testProductivity(collections: [Collection]) {
    var wordCounter = WordCounter()
    for collection in collections {
        let collectionArray = collection.array
        let formattedString = String(format: "\t%-20d%-20d%-20f%-20f",
                                     collection.no,
                                     collection.size,
                                     wordCounter.countWordsSimple(in: collectionArray),
                                     wordCounter.countWordsGcd(in: collectionArray))
        
        print(formattedString)
    }
}

var collectionsGen = CollectionsGen()
collectionsGen.populateCollections()
print("Collection # \t Collection size \t T(no concurrency) \t T(with concurrency)")
testProductivity(collections: collectionsGen.collections)
