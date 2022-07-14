//
//  UserListViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    enum ListType: String {
        case followers
        case following
    }
    
    private let noUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "No Users"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    let user: User
    let type: ListType
    public var users = [String]()
    
    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        switch type {
        case .followers: title = "Followers"
        case .following: title = "Following"
        }
        if users.isEmpty {
            view.addSubview(noUsersLabel)
            noUsersLabel.sizeToFit()
        } else {
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.superview == view {
            tableView.frame = view.bounds
        } else {
            noUsersLabel.center = view.center
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].lowercased()
        cell.selectionStyle = .none
        return cell
    }


}
