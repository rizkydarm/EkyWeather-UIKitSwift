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
    
    @Published var email = ""
    @Published var password = ""
    @Published var isSubmitLoading = false
    @Published var error: String?
    @Published var isLoggedIn = false
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func login() {
        isSubmitLoading = true
        error = nil
        
//        Just("Waited for 1 seconds")
//            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//            .sink { [weak self]  value in
//                self?.isSubmitLoading = false
//            }
//            .store(in: &cancellables)
        
        authUseCase.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSubmitLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
    
    func register() {
        isSubmitLoading = true
        error = nil
        
//        Just("Waited for 1 seconds")
//            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//            .sink { [weak self]  value in
//                self?.isSubmitLoading = false
//            }
//            .store(in: &cancellables)
        
        authUseCase.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSubmitLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
}
