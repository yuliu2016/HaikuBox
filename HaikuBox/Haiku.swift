//
//  Haiku.swift
//  HaikuBox
//
//  Created by Yu Liu on 2015-12-28.
//

import Foundation

// MARK: Type And Marker

let haiku_replace_marker = ("-n", "-v", "-adj", "-adv")

typealias haiku_word_set = ([String], [String], [String], [String])
typealias haiku_list_item = (String, haiku_word_set)
enum haiku_word_types {
    case noun, verb, adjective, adverb
}

// MARK: Sample

let sample_haikus: [haiku_list_item] = [
    ("An -adj -adj -n, A -n -vs into the -n, The sound of -n", (["pond", "frog", "pond", "water"], ["jump"], ["old", "silent"], []))
]

// MARK: Classes

class Haiku {
    
    // MARK: Properties
    
    let template: String
    
    let nouns: [String]
    let verbs: [String]
    let adjectives: [String]
    let adverbs: [String]
    
    
    // MARK: Initializer
    
    
    /*
    Initializes the haiku with the template and the original word set
    */
    
    init(template: String, original: haiku_word_set) {
        self.template = template
        (nouns, verbs, adjectives, adverbs) = original
    }
    
    
    // MARK: Other Methods
    
    
    /*
    Returns a list of three containing each line of the template
    */
    
    func template_lines() -> [String]? {
        let splited = template.componentsSeparatedByString(",")
        
        if splited.count == 3 {
            return splited
        } else {
            return nil
        }
    }
    
    /*
    Returns a tuple containing the original word set
    */
    
    func original_set() -> haiku_word_set {
        return (nouns, verbs, adjectives, adverbs)
    }
    
    /*
    Retrieves the original Haiku
    Calles original_set and replace_set together
    */
    
    func toString() -> String {
        return replace_set(original_set())
    }
    
    /*
    Replaces the the marks in the template with new set
    Returns a String of the replaced set
    */
    
    func replace_set(newset: haiku_word_set) -> String {
        
        let (new_nouns, new_verbs, new_adjectives, new_adverbs) = newset
        var split_template = template.componentsSeparatedByString(" ")
        var wordset_count = (0,0,0,0)
        var temp = "" //contains sufix of each word
        var marker_length = 0
        
        for (count, word) in split_template.enumerate(){
            if new_nouns.count < wordset_count.0 || new_verbs.count < wordset_count.1 || new_adjectives.count < wordset_count.2 || new_adverbs.count < wordset_count.3 {
                break
            }
            
            if word.hasPrefix(haiku_replace_marker.0) {
                
                temp = word
                marker_length = haiku_replace_marker.0.characters.count
                
                temp.removeRange(temp.startIndex...temp.startIndex.advancedBy(marker_length-1))
                
                split_template[count] = new_nouns[wordset_count.0]
                split_template[count] += temp
                wordset_count.0 += 1
                
            } else if word.hasPrefix(haiku_replace_marker.1) {
                temp = word
                marker_length = haiku_replace_marker.1.characters.count
                
                temp.removeRange(temp.startIndex...temp.startIndex.advancedBy(marker_length-1))
                
                split_template[count] = new_verbs[wordset_count.1]
                split_template[count] += temp
                wordset_count.1 += 1
                
            } else if word.hasPrefix(haiku_replace_marker.2) {
                temp = word
                marker_length = haiku_replace_marker.2.characters.count
                
                temp.removeRange(temp.startIndex...temp.startIndex.advancedBy(marker_length-1))
                
                split_template[count] = new_adjectives[wordset_count.2]
                split_template[count] += temp
                wordset_count.2 += 1
                
            } else if word.hasPrefix(haiku_replace_marker.3) {
                temp = word
                marker_length = haiku_replace_marker.3.characters.count
                
                temp.removeRange(temp.startIndex...temp.startIndex.advancedBy(marker_length-1))
                
                split_template[count] = new_adverbs[wordset_count.3]
                split_template[count] += temp
                wordset_count.3 += 1
                
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
    
    func replace_one(new_word: String, type: haiku_word_types, index: Int) -> String? {
        
        var new_set = original_set()
        if index < 0 {
            return nil
        }
        
        switch type{
            
        case .noun:
            guard new_set.0.count > index else {
                return nil
            }
            new_set.0[index] = new_word
            
        case .verb:
            guard new_set.1.count > index else {
                return nil
            }
            new_set.1[index] = new_word
            
        case .adjective:
            guard new_set.2.count > index else {
                return nil
            }
            new_set.2[index] = new_word
        
        case .adverb:
            guard new_set.3.count > index else {
                return nil
            }
            new_set.3[index] = new_word
        }
        
        return replace_set(new_set)
    }
}