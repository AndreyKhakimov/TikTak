//
//  SettingsViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sections = [SettingsSection]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            SettingsSection(
                title: "Preferences",
                options: [
                    SettingsOption(title: "Save Video to Photo library", handler: { }),
                ]
            ),
    
            SettingsSection(
                title: "Information",
                options: [
                    
                    SettingsOption(title: "Terms of Service", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://tiktok.com/legal/terms-of-service") else {
                                return
                            }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    }),
                    
                    SettingsOption(title: "Privacy policy", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://tiktok.com/legal/privacy-policy") else {
                                return
                            }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    })
                ]
            )
        ]
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func createFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        let button = UIButton(frame: CGRect(x: (view.width - 200) / 2, y: 25, width: 200, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }
    
    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(
            title: "Sign Out",
            message: "Would You like to sign out?",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "Sign Out",
                style: .destructive,
                handler: { [weak self] _ in
                    AuthManager.shared.signOut { success in
                        DispatchQueue.main.async {
                            if success {
                                UserDefaults.standard.setValue(nil, forKey: "username")
                                UserDefaults.standard.setValue(nil, forKey: "profile_picture_url")
                                let vc = SignInViewController()
                                let navVC = UINavigationController(rootViewController: vc)
                                navVC.modalPresentationStyle = .fullScreen
                                self?.present(navVC, animated: true, completion: nil)
                                self?.navigationController?.popToRootViewController(animated: true)
                                self?.tabBarController?.selectedIndex = 0
                            } else {
                                // failed
                                let alert = UIAlertController(
                                    title: "Woops",
                                    message: "Something went wrong when signing out. Please, try again.",
                                    preferredStyle: .alert
                                )
                                alert.addAction(
                                    UIAlertAction(
                                        title: "Dismiss",
                                        style: .cancel,
                                        handler: nil
                                    )
                                )
                                self?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            )
        )
        present(actionSheet, animated: true)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        if model.title == "Save Video to Photo library" {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath) as? SwitchTableViewCell else {
                    return UITableViewCell()
                }
            cell.delegate = self
            cell.configure(with: SwitchCellViewModel(title: model.title, isOn: UserDefaults.standard.bool(forKey: "save_video")))
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
}

// MARK: - SwitchTableViewCellDelegate
extension SettingsViewController: SwitchTableViewCellDelegate {
    
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool) {
        print(isOn)
        UserDefaults.standard.setValue(isOn, forKey: "save_video")
    }
    
}
