//
//  WeatherViewController.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import UIKit

class WeatherViewController: WFBaseController {
    // MARK: - Declarations
    @IBOutlet weak var weatherTable: UITableView!
    var viewModel: WeatherViewModel?
    var bookMarkLocation: BookMarkPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        self.createNavigationItems()
        self.setTableview()
        
        if let model = viewModel, let bookLocation = bookMarkLocation {
            if WFReachability.isNetworkAvaible() {
                self.createSpinnerView()
                model.getFutureWeatherData(location: bookLocation, onSuccess: {(location) in
                    DispatchQueue.main.sync {
                        self.reloadTableView()
                        self.removeSpinnerView()
                    }
                }, onError: {(error) in
                    self.showAlert(title: "Alert", message: "\(error.statusMessage )")
                })
            } else {
                self.showNoInternetConnection()
            }
        }
        if let location = bookMarkLocation {
            self.navigationItem.title  = (location.city ?? "") + ", " + (location.country ?? "")
        }
    }
    
    func setLocationData(location: BookMarkPlace?) {
        self.bookMarkLocation = location
    }
    
    func reloadTableView() {
        self.weatherTable.reloadData()
    }
}
// MARK: - Navigation Barbuttons
extension WeatherViewController {
    func createNavigationItems() {
        let cancelItem = UIBarButtonItem(image: UIImage(named: "cancel"), style: .done, target: self, action: #selector(cancelClicked))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    @objc func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Tableview

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func setTableview() {
        self.weatherTable.delegate = self
        self.weatherTable.dataSource = self
        self.weatherTable.estimatedRowHeight = 300
        self.weatherTable.rowHeight = UITableView.automaticDimension
        self.weatherTable.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = viewModel, let data = model.sortedKeys {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.WeatherCellIdentifier.rawValue, for: indexPath) as UITableViewCell
        if let cellIs = cell as? WeatherCell {
            cellIs.selectionStyle = .none
            if let model = viewModel, let data = model.sortedKeys, let forcastArray = model.displayData, let cityData = model.futureForcast?.city {
                if let dataIs = forcastArray["\(data[indexPath.row])"]?.first {
                    cellIs.setData(forcastData: dataIs, city: cityData)
                }
            }
        }
        return cell
    }
}
