import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct WordCounter {
    var randomWords = [
        "Blossom","Blossom","Blossom", "Labyrinth","Nimbus",
        "Placid", "Mellifluous", "Labyrinth", "Placid",
        "Whimsical","Blossom","Nebula", "Labyrinth", "Placid", "Mellifluous",
        "Nebulous", "Labyrinth", "Juxtapose", "Mellifluous",
        "Mellifluous", "Mellifluous", "Nebula", "Nebula", "Mellifluous"
    ]
    
    func countWordsSimple() -> ([String: Int], UInt64) {
        let start = DispatchTime.now()
        let countDictionary = randomWords.reduce(into: [:]) { counts, word in
            counts[word, default: 0] += 1
        }
        let end = DispatchTime.now()
        let time = end.uptimeNanoseconds - start.uptimeNanoseconds
        return (countDictionary, time)
    }
    
    func countWordsGcd() -> ([String : Int], UInt64) {
        var countDictionary: [String : Int] = [:]
        
        let queue = DispatchQueue(label: "ua.kma.kucherenko.wordcount", attributes: .concurrent)
        let group = DispatchGroup()
        
        let start = DispatchTime.now()
        randomWords.forEach { word in
            let wordCountIncrement = DispatchWorkItem {
                // increment number of words in dictionary
                countDictionary[word, default: 0] += 1
            }
            group.enter()
            queue.async(execute: wordCountIncrement)
            group.leave()
        }
        let end = DispatchTime.now()
        let time = end.uptimeNanoseconds - start.uptimeNanoseconds
        return (countDictionary, time)
    }
}

var simpleWC = WordCounter()
simpleWC.randomWords.shuffle()
print(simpleWC.countWordsSimple())
print()
print(simpleWC.countWordsGcd())

