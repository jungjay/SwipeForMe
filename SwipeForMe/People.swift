//
//  People.swift
//  SwipeForMe
//
//  Created by Jay Jung on 5/6/21.
//

import Foundation
import Firebase

class People {
    var personArray: [Person] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping() -> ()) {
        db.collection("people").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.personArray = [] // clean out existing personArray since new data will load
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // you'll have to make sure you have a dictionary initializer in the singular class
                let person = Person(dictionary: document.data())
                person.documentID = document.documentID
                self.personArray.append(person)
            }
            completed()
        }
    }
}

