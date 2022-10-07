//
//  ViewController.swift
//  Crypto Tracker_DemoPractice
//
//  Created by tmtech1 on 07/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModel = [CryptoTableViewCellViewModel]()
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Crypto Tracker"
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // call api
        APICaller.shared.getAllCryptoData { [weak self] result in
            switch result {
                case .success(let models):
                    
                    self?.viewModel = models.compactMap({ model in
                        
                        // number formatter
                        let price = model.price_usd ?? 0
                        let formatter = ViewController.numberFormatter
                        let priceString = formatter.string(from: NSNumber(value: price))
                        
                        let iconUrl = URL(string: APICaller.shared.icons.filter ({ icon in
                            icon.asset_id == model.asset_id
                        }).first?.url ?? "")

                        return CryptoTableViewCellViewModel(
                            name: model.name ?? "N/A",
                            symbol: model.asset_id,
                            price: priceString ?? "N/A",
                            iconUrl: iconUrl
                        )
                    })
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("error:- \(error)")
                
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { fatalError() }
        cell.configure(with: viewModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
