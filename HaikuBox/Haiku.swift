//
//  Haiku.swift
//  HaikuBox
//
//  Created by Yu Liu on 2015-12-28.
//
import Foundation

// MARK: Type, Marker, and Functions

let haiku_replace_marker = ["-n", "-v", "-adj", "-adv"]
let haiku_newline_marker = ","

typealias haiku_word_set = [[String]]
typealias haiku_list_item = (String, haiku_word_set)

enum haiku_word_types: Int{
    case noun = 0
    case verb = 1
    case adjective = 2
    case adverb = 3
}

// MARK: Sample

let sample_haikus: [haiku_list_item] = [
    ("An -adj -adj -n, A -n -vs into the -n, The sound of -n", [["pond", "frog", "pond", "water"], ["jump"], ["old", "silent"], []]),
    
    ("lightning -n, what I thought were -n, are plumes of -n grass", [["flash", "faces", "pampas"], [], [], []]),
    
    ("A summer -n being -ved, how -adj, with -n in my -n!", [["river", "sandals", "hands"], ["cross"], ["pleasing"], []]),
    
    ("-n of the -n, moves west- -n's shadows, -v -adv", [["light", "moon", "flowers"], ["move"], [], ["eastward"]]),
    
    ("In the -n, The -n of the -n, -vs far away", [["moonlight", "color and scent", "wisteria"], ["seem"], [], []]),
    
    ("O -n, Climb -n, But -adv", [["snail", "Mount Fuji",], ["seem"], [], ["slowly"]]),
    
    ("Trusting the -n- good and bad, I bid farewell, To the departing -n", [["Buddha", "year"], [], [], []]),
    
    ("Everything I -v, with -n- alas, -vs like a -n", [["tenderness", "bramble",], ["touch", "prick"], [], []]),
    
    ("Over the wintry, forest, -ns howl in rage, -with no -ns to -v", [["wind", "leave",], ["blow"], [], []]),
    
    ("The -n has flown away, -ving in the evening -n, a -adj -n", [["crow", "sun", "tree"], ["sway"], ["leafless"], []]),
]

// MARK: Classes

class Haiku {
    
    // MARK: Properties
    let template: String
    let original: haiku_word_set
    
    // MARK: Methods
    
    init(_ template: String, withSet original: haiku_word_set) {
        self.template = template
        self.original = original
    }
    
    convenience init(_ data: haiku_list_item) {
        self.init(data.0, withSet: data.1)
    }
    
    /*
    Returns an array of three containing each line of the template
    */
    func split_lines() -> [String]? {
        let splited = template.componentsSeparatedByString(haiku_newline_marker)
        if splited.count == 3 {
            return splited
        } else {
            return nil
        }
    }
    
    /*
    Retrieves the original Haiku
    */
    func toString() -> String {
        return replace_set(original)
    }
    
    /*
    Replaces the the marks in the template with new set
    Returns a String of the replaced set
    */
    func replace_set(newset: haiku_word_set) -> String {
        
        var split_template = template.componentsSeparatedByString(" ")
        var wordset_count: [Int] = [0,0,0,0]
        var temp = "" //contains sufix of each word
        var marker_length = 0
        
        //iterates through the array
        for (count, word) in split_template.enumerate(){
            for i in [0,1,2,3] {
                if word.hasPrefix(haiku_replace_marker[i]) {
                    marker_length = haiku_replace_marker[i].characters.count
                    temp = word
                    temp.removeRange(temp.startIndex..<temp.startIndex.advancedBy(marker_length))
                    
                    split_template[count] = newset[i][wordset_count[i]]
                    split_template[count] += temp
                    wordset_count[i] += 1
                    break
                }
            }
        }
        
        var returned_string = ""
        for word in split_template {
            returned_string = returned_string + word
            returned_string = returned_string + " "
        }
        return returned_string
    }
    
    /*
    Replaces one specific word in the haiku template
    Also replaces the other marks -n -v -adj and -adv with the original word set
    Returns a string of the result replacement
    */
    func replace_a_word(new_word: String, ofType type: haiku_word_types, atIndex index: Int) -> String? {
        
        var new_set = original
        if index < 0 || new_set.count < type.rawValue || new_set[type.rawValue].count <= index{
            return nil
        }
        
        new_set[type.rawValue][index] = new_word
        return replace_set(new_set)
        
    }
    
    func randIndex(type: haiku_word_types) -> Int? {
        let count = original[type.rawValue].count
        
        if count == 0 {
            return nil
        }
        return random() % original[type.rawValue].count
    }
}

class HaikuManager {
    
    // MARK: Properties
    
    var managedHaikus: [Haiku]
    var currentHaiku: Haiku!
    var type: haiku_word_types = .noun
    
    // MARK: Main Methods
    
    init() {
        managedHaikus = []
    }
    
    func loadSamples() {
        addHaikus(sample_haikus)
    }
    
    func changeType(type: haiku_word_types) {
        self.type = type
    }
    
    func oneWord(word: String) -> String? {
        let randHaiku = randomHaiku()
        if randHaiku.randIndex(type) == nil {
            return nil
        }
        return randHaiku.replace_a_word(word, ofType: type, atIndex: randHaiku.randIndex(type)!)
    }
    
    func scramble1() -> Haiku? {
        return nil
    }
    
    func scramble2() -> Haiku? {
        return nil
    }
    
    func scramble3(current_haiku: Haiku) -> Haiku? {
        return nil
    }
    
    // MARK: Helper methods
    
    func addHaikus(new_haikus: [haiku_list_item]) {
        for new_haiku in new_haikus {
            managedHaikus.append(Haiku(new_haiku))
        }
    }
    
    func randomHaikuId() -> Int {
        return random() % managedHaikus.count
    }
    
    func getHaikuById(id: Int) -> Haiku {
        return managedHaikus[id]
    }
    
    func randomHaiku() -> Haiku {
        return getHaikuById(randomHaikuId())
    }
    
    func randomLine(id: Int?) -> String? {
        let lines = randomHaiku().split_lines()
        if lines == nil {
            return nil
        } else {
            return lines![random() % 3]
        }
    }
    
    
}
