//
//  RealmService.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 26.11.2022.
//

import Foundation
import RealmSwift
import Realm

class RealmService {

    static let shared = RealmService()
    
    private let realm = try! Realm()
    
    func saveRecodr(model: NumberModel) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    func getAllrecords() -> Results<NumberModel> {
        let numberModels = realm.objects(NumberModel.self).sorted(byKeyPath: "date", ascending: false)
        return numberModels
    }
    
    func subscribeNotification(object: Results<NumberModel>, completion: @escaping Callback<[Int]>) -> NotificationToken? {
        
        let notificationToken = object.observe { (changes) in
            
            switch changes {
            case .initial(_):
                break
            case .update(_, deletions: _, insertions: let insertions, modifications: _):
                completion(insertions)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        return notificationToken
    }
    
    func invalidateSubscription(_ notificationToken: NotificationToken) {
        notificationToken.invalidate()
    }
}


