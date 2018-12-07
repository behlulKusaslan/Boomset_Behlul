//
//  KeyedArchiverManager.swift
//  Boomset_behlul
//
//  Created by behlul on 7.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation

class KeyedArchiverManager {
    
    // singleton
    static let shared = KeyedArchiverManager()
    
    let mutableData = NSMutableData()
    
    private func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as NSString
        return documentDirectory
    }
    
    func writeAttendeesResult(_ arrayToSave: [AttendeesResult]) {
        let archiver = NSKeyedArchiver(forWritingWith: mutableData)
        for objectToSave in arrayToSave {
            do {
                if isSaved(for: objectToSave) {
                    continue
                }
                let keyToSave = "\(objectToSave.id)"
                try archiver.encodeEncodable(objectToSave, forKey: keyToSave)
                saveAttendeesResultKey(keyToSave)
            } catch {
                print("archiver error")
            }
        }
        archiver.finishEncoding()
    }
    
    func readAttendeesResult() -> [AttendeesResult] {
        var attendeesResults = [AttendeesResult]()
        let unarchiver = NSKeyedUnarchiver(forReadingWith: mutableData as Data)
        for key in UserDefaults.standard.stringArray(forKey: UserDefaultsKey.ARCHIVER_ATTENDEES) ?? [String]() {
            do {
                if let attendeesResult = try unarchiver.decodeTopLevelDecodable(AttendeesResult.self, forKey: key) {
                    print("deserialized attendees output: \(attendeesResult)")
                    attendeesResults.append(attendeesResult)
                }
            } catch {
                print("unarchiving failure: \(error)")
            }
        }
        return attendeesResults
    }
    
    private func isSaved(for attendeesresult: AttendeesResult) -> Bool {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: mutableData as Data)
        let key = String(attendeesresult.id)
        do {
            if let _ = try unarchiver.decodeTopLevelDecodable(AttendeesResult.self, forKey: key) {
                return true
            }
            return false
        } catch {
            return false
        }
    }
    
    private func saveAttendeesResultKey(_ newKey: String) {
        if var previusKeys = UserDefaults.standard.stringArray(forKey: UserDefaultsKey.ARCHIVER_ATTENDEES) {
            previusKeys = previusKeys.filter { $0 != newKey }
            previusKeys.append(newKey)
            UserDefaults.standard.set(previusKeys, forKey: UserDefaultsKey.ARCHIVER_ATTENDEES)
        } else {
            let keyToSaveArray = [newKey]
            UserDefaults.standard.set(keyToSaveArray, forKey: UserDefaultsKey.ARCHIVER_ATTENDEES)
        }
        debugPrint(UserDefaults.standard.stringArray(forKey: UserDefaultsKey.ARCHIVER_ATTENDEES) ?? [String]())
    }
    
}

extension KeyedArchiverManager {
    enum Path: String {
        case attendees = "AttendeesPath"
    }
}
