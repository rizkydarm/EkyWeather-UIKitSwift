//
//  AuthError.swift
//  EkyWeather
//
//  Created by Eky on 22/01/25.
//


import Combine

class ForecastRepositoryImpl {
    private let forcastApiManager: ForecastApiManager
    
    init() {
        self.forcastApiManager = .shared
    }
    
    func getCurrent(latitude: Double, longitude: Double) -> AnyPublisher<CurrentForecastEntity, Error> {
        return Future { [weak self] promise in
            self?.forcastApiManager.getCurrent(latitude: latitude, longitude: longitude) { result in
                switch result {
                case .success(let model):
                    let entity = CurrentForecastEntity.fromResponseModel(model)
                    promise(.success(entity))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    func getOneDay(latitude: Double, longitude: Double) -> AnyPublisher<OneDayForecastEntity, Error> {
        return Future { [weak self] promise in
            self?.forcastApiManager.getHourly(latitude: latitude, longitude: longitude) { result in
                switch result {
                case .success(let model):
                    let entity = OneDayForecastEntity.fromResponseModel(model)
                    promise(.success(entity))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    func getSevenDays(latitude: Double, longitude: Double) -> AnyPublisher<SevenDaysForecastEntity, Error> {
        return Future { [weak self] promise in
            self?.forcastApiManager.getDaily(latitude: latitude, longitude: longitude) { result in
                switch result {
                case .success(let model):
                    let entity = SevenDaysForecastEntity.fromResponseModel(model)
                    promise(.success(entity))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()

    }
    
//    func register(email: String, password: String) -> AnyPublisher<UserEntity, Error> {
//        return Future { [weak self] promise in
//            // Check if user already exists
//            let existingUser = self?.realmManager.query(UserRealmObject.self, 
//                predicate: NSPredicate(format: "email == %@", email))
//            
//            if existingUser?.first != nil {
//                promise(.failure(AuthError.userAlreadyExists))
//                return
//            }
//            
//            // Create new user
//            let userObject = UserRealmObject(email: email, password: password)
//            
//            do {
//                try self?.realmManager.create(userObject)
//                promise(.success(userObject.toDomain()))
//            } catch {
//                promise(.failure(error))
//            }
//        }.eraseToAnyPublisher()
//    }
//    
//    func login(email: String, password: String) -> AnyPublisher<UserEntity, Error> {
//        return Future { [weak self] promise in
//            let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
//            let user = self?.realmManager.query(UserRealmObject.self, predicate: predicate).first
//            
//            if let user = user {
//                promise(.success(user.toDomain()))
//            } else {
//                promise(.failure(AuthError.invalidCredentials))
//            }
//        }.eraseToAnyPublisher()
//    }
}
