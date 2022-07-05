//
//  AuthField.swift
//  TikTak
//
//  Created by Andrey Khakimov on 04.07.2022.
//

import UIKit

class AuthField: UITextField {
    
    enum FieldType {
        case email
        case password
        case userName
        
        var title: String {
            switch self {
            case .email: return "Email Address"
            case .password: return "Password"
            case .userName: return "Username"
            }
        }
    }
    
    private let type: FieldType

    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
        
        if type == .password {
            isSecureTextEntry = true
        }
        if type == .email {
            keyboardType = .emailAddress
        }
    }

}
