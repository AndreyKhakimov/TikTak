//
//  NotificationsViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var notifications = [Notification]()
    
    private let notificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.isHidden = true
        tableview.register(
            NotificationsUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier
        )
        
        tableview.register(
            NotificationsPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier
        )
        
        tableview.register(
            NotificationsPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier
        )
        
        tableview.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return tableview
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableview)
        view.addSubview(notificationsLabel)
        view.addSubview(spinner)
        
        view.backgroundColor = .systemBackground
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.refreshControl = refreshControl
        
        fetchNotifications()
    }
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.notifications = notifications
                self?.tableview.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
        notificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        notificationsLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotifications() {
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        if notifications.isEmpty {
            notificationsLabel.isHidden = false
            tableview.isHidden = true
        } else {
            notificationsLabel.isHidden = true
            tableview.isHidden = false
        }
        
        tableview.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource methods
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = notifications[indexPath.row]
        
        switch notification.type {
        case .postLike(postName: let postName):
            guard let cell = tableview.dequeueReusableCell(
                withIdentifier: NotificationsPostLikeTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostLikeTableViewCell else {
                return tableview.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: postName, notification: notification)
            return cell
        case .userFollow(userName: let userName):
            guard let cell = tableview.dequeueReusableCell(
                withIdentifier: NotificationsUserFollowTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsUserFollowTableViewCell else {
                return tableview.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: userName, notification: notification)
            return cell
        case .postComment(postName: let postName):
            guard let cell = tableview.dequeueReusableCell(
                withIdentifier: NotificationsPostCommentTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostCommentTableViewCell else {
                return tableview.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: postName, notification: notification)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let notification = notifications[indexPath.row]
        notification.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: notification.identifier) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.notifications = self?.notifications.filter({ $0.isHidden == false }) ?? []
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
        }
    }
    
}

// MARK: - NotificationsUserFollowTableViewCellDelegate
extension NotificationsViewController: NotificationsUserFollowTableViewCellDelegate {
    
    func notificationsUserFollowTableViewCellDelegate(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.updateRelationship(
            for: User(
                username: username,
                profilePictureURL: nil,
                identifier: UUID().uuidString),
               follow: true
        ) { success in
            if !success {
                // something went wrong
            }
        }
    }
    
    func notificationsUserFollowTableViewCellDelegate(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String) {
        HapticsManager.shared.vibrateForSelection()
        let vc = ProfileViewController(
            user: User(
                username: username,
                profilePictureURL: nil,
                identifier: "123")
        )
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - NotificationsPostLikeTableViewCellDelegate
extension NotificationsViewController: NotificationsPostLikeTableViewCellDelegate {
    
    func notificationsPostLikeTableViewCell(_ cell: NotificationsPostLikeTableViewCell, didTapPostWith identifier: String) {
        HapticsManager.shared.vibrateForSelection()
        openPost(with: identifier)
    }
    
}

// MARK: - NotificationsPostCommentTableViewCellDelegate
extension NotificationsViewController: NotificationsPostCommentTableViewCellDelegate {
    
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
    
}

extension NotificationsViewController {
    func openPost(with identifier: String) {
        let vc = PostViewController(
            model: PostModel(
                identifier: identifier, user: User(
                    username: "Bob",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                )
            )
        )
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
