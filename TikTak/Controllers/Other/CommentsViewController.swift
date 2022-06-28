//
//  CommentsViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 26.06.2022.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {
    
    weak var delegate: CommentsViewControllerDelegate?
    
    private let post: PostModel
    
    private var comments = [PostComment]()
    
    private let tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableview
    }()
    
    private let closeButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        view.addSubview(tableview)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .white
        fetchPostComments()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 28, y: 8, width: 20, height: 20)
        tableview.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.height - closeButton.bottom)
    }
    
    @objc private func didTapClose() {
        delegate?.didTapCloseComments(with: self)
    }
    
    func fetchPostComments() {
        //DatabaseManager.share.fetchComment
        comments = PostComment.mockComments()
    }

}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
       guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
