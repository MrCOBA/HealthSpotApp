//
//  SettingsTableViewController.swift
//  HealthSpot
//
//  Created by Oparin on 27.05.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var dataSource: [SettingsTableViewCell.CellModel] = [
        .init(isSettingOn: true,
              title: "Notifications",
              subtitle: "You will no longer receive notifications about your medication"),
        .init(isSettingOn: false,
              title: "Offline mode",
              subtitle: "Use app only with fetched data")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.cellIdentifier)
        navigationItem.title = "Settings"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellIdentifier,
                                                       for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }

        cell.cellModel = dataSource[indexPath.row]
        return cell
    }
    
}
