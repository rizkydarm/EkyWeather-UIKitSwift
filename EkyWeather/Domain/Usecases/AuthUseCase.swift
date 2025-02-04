//
//  AuthUseCase.swift
//  EkyWeather
//
//  Created by Eky on 22/01/25.
//


import Combine

protocol AuthUseCase {
    func register(email: String, password: String) -> AnyPublisher<UserEntity, Error>
    func login(email: String, password: String) -> AnyPublisher<UserEntity, Error>
}

class AuthUseCaseImpl: AuthUseCase {
    private let repository: AuthRepository
    
    init() {
        self.repository = AuthRepositoryImpl()
    }
    
    func register(email: String, password: String) -> AnyPublisher<UserEntity, Error> {
        repository.register(email: email, password: password)
    }
    
    func login(email: String, password: String) -> AnyPublisher<UserEntity, Error> {
        repository.login(email: email, password: password)
    }
}
