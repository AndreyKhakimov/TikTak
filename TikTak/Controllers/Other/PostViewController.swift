//
//  PostViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import UIKit

class PostViewController: UIViewController {
    
    let model: PostModel
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colors: [UIColor] = [
            .green, .orange, .brown, .cyan, .white, .systemPink
        ]
        view.backgroundColor = colors.randomElement()
    }

}
