//
//  QueryViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import UIKit

class HisoryViewController: UITableViewController {
    
    var viewModel: HistoryViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    private func setupViews() {
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.cellId)
    }
    
}
extension HisoryViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.cellId, for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        cell.configure()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

