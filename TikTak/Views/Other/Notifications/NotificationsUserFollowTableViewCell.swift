//
//  NotificationsUserFollowTableViewCell.swift
//  TikTak
//
//  Created by Andrey Khakimov on 09.07.2022.
//

import UIKit

class NotificationsUserFollowTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationsUserFollowTableViewCell"
    
    private let avatarImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
       let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        contentView.addSubview(followButton)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconSize: CGFloat = 50
        avatarImageView.layer.cornerRadius = iconSize / 2
        avatarImageView.frame = CGRect(
            x: 10,
            y: 3,
            width: iconSize,
            height: iconSize
        )
        
        followButton.sizeToFit()
        followButton.frame = CGRect(
            x: contentView.width - 110,
            y: 10,
            width: 100,
            height: 30
        )
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(
            CGSize(
            width: contentView.width - 30 - followButton.width - iconSize,
            height: contentView.height - 40
            )
        )
        
        label.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 0,
            width: labelSize.width,
            height: labelSize.height
        )
        
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: label.bottom + 3,
            width: contentView.width - avatarImageView.width - followButton.width,
            height: 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    func configure(with userName: String, notification: Notification) {
        avatarImageView.image = UIImage(named: "Test")
        label.text = notification.text
        dateLabel.text = .date(with: notification.date)
    }
    
}
