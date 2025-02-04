//
//  HomeViewController.swift
//  EkyWeather
//
//  Created by Eky on 20/01/25.
//

import UIKit
import SnapKit
import Combine

class ProfileViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let items = Array(1...10).map { "Item \($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.titleLabel
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = items[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = item
        config.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        config.textProperties.color = .titleLabel
        
        config.secondaryText = "Subtitle for \(item)"
        config.secondaryTextProperties.font = .systemFont(ofSize: 14)
        config.secondaryTextProperties.color = .secondaryLabel
        
        cell.contentConfiguration = config
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: imageConfig))
        cell.backgroundColor = .quaternarySystemFill
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    return ProfileViewController()
}
