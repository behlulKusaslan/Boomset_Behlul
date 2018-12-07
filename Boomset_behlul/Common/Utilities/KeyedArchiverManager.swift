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
    
    func writeAttendeesResult(_ arrayToSave: [AttendeesResult], for eventId: Int) {
        for objectToSave in arrayToSave {
            let keyToSave = "\(eventId)+\(objectToSave.id)"
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(objectToSave) {
                UserDefaults.standard.set(encoded, forKey: keyToSave)
                saveAttendeesResultKey(keyToSave, for: eventId)
            }
        }
    }
    
    func readAttendeesResult(for eventId: Int) -> [AttendeesResult] {
        let eventKey = UserDefaultsKey.ARCHIVER_ATTENDEES + "+\(eventId)"
        var attendeesResults = [AttendeesResult]()
        let decoder = JSONDecoder()
        for key in UserDefaults.standard.stringArray(forKey: eventKey) ?? [String]() {
            if let attendeesData = UserDefaults.standard.data(forKey: key),
                let attendeesResult = try? decoder.decode(AttendeesResult.self, from: attendeesData) {
                attendeesResults.append(attendeesResult)
            }
        }
        return attendeesResults.sorted { $0.modified < $1.modified }
    }
    
    private func saveAttendeesResultKey(_ newKey: String, for eventId: Int) {
        let eventKey = UserDefaultsKey.ARCHIVER_ATTENDEES + "+\(eventId)"
        if var previusKeys = UserDefaults.standard.stringArray(forKey: eventKey) {
            previusKeys = previusKeys.filter { $0 != newKey }
            previusKeys.append(newKey)
            UserDefaults.standard.set(previusKeys, forKey: eventKey)
        } else {
            let keyToSaveArray = [newKey]
            UserDefaults.standard.set(keyToSaveArray, forKey: eventKey)
        }
        debugPrint(UserDefaults.standard.stringArray(forKey: eventKey) ?? [String]())
    }
    
}

extension KeyedArchiverManager {
    enum Path: String {
        case attendees = "AttendeesPath"
    }
}
