//
//  SwitchTableViewCell.swift
//  TikTak
//
//  Created by Andrey Khakimov on 15.07.2022.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    static let identifier = "SwitchTableViewCell"
    
    weak var delegate:  SwitchTableViewCellDelegate?
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let customSwitch: UISwitch = {
       let customSwitch = UISwitch()
        customSwitch.onTintColor = .systemBlue
        customSwitch.isOn = UserDefaults.standard.bool(forKey: "save_video")
        return customSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(customSwitch)
        customSwitch.addTarget(self, action: #selector(didChangeSwitchValue), for: .valueChanged)
    }
    
    @objc func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.switchTableViewCell(self, didUpdateSwitchTo: sender.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 0, width: label.width, height: contentView.height)
        
        customSwitch.sizeToFit()
        customSwitch.frame = CGRect(x: contentView.width - customSwitch.width - 10, y: 6, width: customSwitch.width, height: customSwitch.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: SwitchCellViewModel) {
        label.text = viewModel.title
        customSwitch.isOn = viewModel.isOn
    }

}
