//
//  UserRealmObject.swift
//  EkyWeather
//
//  Created by Eky on 22/01/25.
//

import RealmSwift

class UserRealmObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var email: String = ""
    @Persisted var password: String = ""
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
    
    func toDomain() -> UserEntity {
        return UserEntity(id: id, email: email, password: password)
    }
}
