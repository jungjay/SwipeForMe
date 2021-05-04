//
//  Person.swift
//  SwipeForMe
//
//  Created by Jay Jung on 5/4/21.
//

import Foundation
import Firebase

class Person {
    var name: String
    var status: String
    var year: String
    var campus: String
    var balance: String
    var contactMethod: String
    var contactInfo: String
    
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "status": status, "year": year, "campus": campus, "balance": balance, "contactMethod": contactMethod, "contactInfo": contactInfo, "postingUserID": postingUserID]
    }
    
    init(name: String, status: String, year: String, campus: String, balance: String, contactMethod: String, contactInfo: String, postingUserID: String, documentID: String) {
        self.name = name
        self.status = status
        self.year = year
        self.campus = campus
        self.balance = balance
        self.contactMethod = contactMethod
        self.contactInfo = contactInfo
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(name: "", status: "", year: "", campus: "", balance: "", contactMethod: "", contactInfo: "", postingUserID: "", documentID: "")
    }
    
    func saveData(completion: @escaping (Bool)->()) {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // If we HAVE a saved record, we'll have an ID, otherwise, .addDocument will create one.
        if self.documentID == "" { // Create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("people").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)") // IT WORKED!
                completion(true)
            }
        } else { // else save to the existing document with .setData
            let ref = db.collection("people").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document: \(self.documentID)") // IT WORKED!
                completion(true)
            }
        }
    }
}
