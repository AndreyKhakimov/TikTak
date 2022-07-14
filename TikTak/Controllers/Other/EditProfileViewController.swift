//
//  EditProfileViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 14.07.2022.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem =  UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

}
