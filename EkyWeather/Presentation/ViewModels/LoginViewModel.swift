//
//  LoginViewModel.swift
//  EkyWeather
//
//  Created by Eky on 18/01/25.
//

import Foundation
import Combine

class LoginViewModel: BaseViewModel {
    
    private let authUseCase: AuthUseCase
    
    // Published properties
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var isLoggedIn = false
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func login() {
        isLoading = true
        error = nil
        
        authUseCase.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
    
    func register() {
        isLoading = true
        error = nil
        
        authUseCase.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
}
