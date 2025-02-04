//
//  AuthRepository.swift
//  EkyWeather
//
//  Created by Eky on 22/01/25.
//


import Combine

protocol AuthRepository {
    func register(email: String, password: String) -> AnyPublisher<UserEntity, Error>
    func login(email: String, password: String) -> AnyPublisher<UserEntity, Error>
}
