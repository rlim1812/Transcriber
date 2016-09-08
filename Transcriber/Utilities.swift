//
//  Utilities.swift
//  Transcriber
//
//  Created by Ryan Lim on 9/6/16.
//  Copyright © 2016 Ryan Lim. All rights reserved.
//

import Foundation

class Utilities {
    
    var dateTimeString: String? = String()
    
    func getDocsDirectory() -> URL {
        let paths = FileManager.default.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
        let docsDirect = paths[0]
        return docsDirect
    }
    
    func getAudioFileUrl () -> URL? {
        do {
            let audioUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".m4a")
            return audioUrl
        } catch _ {
            return nil
        }
    }
    
    func getTextFileUrl () -> URL? {
        do {
            let textUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".txt")
            return textUrl
        } catch _ {
            return nil
        }
    }
    
    func getDateAndTime() -> String {
        if let date = dateTimeString {
            return date
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let timeString = formatter.string(from: date)
        return timeString
    }
}
