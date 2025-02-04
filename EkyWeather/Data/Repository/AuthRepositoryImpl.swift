//
//  AuthError.swift
//  EkyWeather
//
//  Created by Eky on 22/01/25.
//


import Combine
import RealmSwift

enum AuthError: Error {
    case userAlreadyExists
    case invalidCredentials
    case unknown
}

class AuthRepositoryImpl: AuthRepository {
    private let realmManager: RealmManager
    
    init() {
        self.realmManager = .shared
    }
    
    func register(email: String, password: String) -> AnyPublisher<UserEntity, Error> {
        return Future { [weak self] promise in
            // Check if user already exists
            let existingUser = self?.realmManager.query(UserRealmObject.self, 
                predicate: NSPredicate(format: "email == %@", email))
            
            if existingUser?.first != nil {
                promise(.failure(AuthError.userAlreadyExists))
                return
            }
            
            // Create new user
            let userObject = UserRealmObject(email: email, password: password)
            
            do {
                try self?.realmManager.create(userObject)
                promise(.success(userObject.toDomain()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<UserEntity, Error> {
        return Future { [weak self] promise in
            let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
            let user = self?.realmManager.query(UserRealmObject.self, predicate: predicate).first
            
            if let user = user {
                promise(.success(user.toDomain()))
            } else {
                promise(.failure(AuthError.invalidCredentials))
            }
        }.eraseToAnyPublisher()
    }
}
