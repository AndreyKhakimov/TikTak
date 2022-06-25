//
//  AuthenticationManager.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    public static let shared = AuthManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    // Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
    
}
