//
//  MainViewController.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import UIKit
import CoreLocation
class MainViewController: WFBaseController {
    
    @IBOutlet weak var help: UIBarButtonItem!
    @IBOutlet weak var addLocation: UIBarButtonItem!
    @IBOutlet weak var mainTableView: UITableView!
    var viewModel: MainViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MainViewModel()
        self.navigationItem.title = "Weather Forecast"
        self.navigationController?.navigationBar.barTintColor = .appBlueColor
        WFUtility.setUnitsValue()
        self.setBookMarkData()
        self.setTableview()

    }

    func setBookMarkData() {
        if let model = viewModel {
            if WFReachability.isNetworkAvaible() {
            self.createSpinnerView()
            model.getbookMarkData()
            model.getCurrentLocation(onSuccess: {(location) in
                WFStore.shared.currentLocation = location
                model.gettodaysWeatherData(location: location, onSuccess: {(location) in
                    DispatchQueue.main.sync {
                        self.reloadTableView()
                        self.removeSpinnerView()
                    }
                }, onError: {(error) in
                    self.showAlert(title: "Alert", message: "\(error.statusMessage )")
                })
            })
            } else {
                self.showNoInternetConnection()
            }
        }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
        self.mainTableView.reloadData()
        }
    }
    
    func reloadDataAndTable() {
        if let model = viewModel {
            model.getbookMarkData()
            DispatchQueue.main.async {
             self.mainTableView.reloadData()
            }
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableview() {
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.estimatedRowHeight = 300
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if let model = viewModel {
                return model.bookmarkedData?.count ?? 0
            }
        default:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let view = UIView()
            view.backgroundColor = UIColor.systemGroupedBackground
            let headerLabel = LabelPadding(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
            headerLabel.text = "Saved Locations"
            headerLabel.textColor = UIColor.black
            headerLabel.numberOfLines = 0
            headerLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            view.addSubview(headerLabel)
            return view
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.MainCurrentCellIdentiier.rawValue, for: indexPath) as UITableViewCell
            if let cellIs = cell as? MainCurrentCell {
                cellIs.selectionStyle = .none
                if let model = viewModel {
                    cellIs.setTableCellData(information: WFStore.shared.currentLocation, forcast: model.locationForcast)
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.BookMarkCellIdentiier.rawValue, for: indexPath) as UITableViewCell
            if let cellIs = cell as? BookMarkCell {
                cellIs.selectionStyle = .none
                if let model = viewModel, let data = model.bookmarkedData {
                    cellIs.setTableCellData(city: data[indexPath.row])
                }
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
    }
    

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1:
            return true
        default:
            return false
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if WFReachability.isNetworkAvaible() {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
                let navigationControl = WFNavigationController(rootViewController: controller)
                switch indexPath.section {
                case 0:
                    controller.setLocationData(location: WFUtility.convertLocationToBookMarkedData(location: WFStore.shared.currentLocation))
                default:
                    if let model = viewModel, let location = model.bookmarkedData?[indexPath.row] {
                        controller.setLocationData(location: location)
                    }
                }
                navigationControl.modalPresentationStyle = .fullScreen
                self.present(navigationControl, animated: true, completion: nil)
            }
        } else {
            self.showNoInternetConnection()
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success: @escaping (Bool) -> Void) in
            print("Delete Clicked")
            
            self.showAlertWithAction(title: "Alert", message: "Are you sure you want to delete?", actionTitles: ["Yes", "No"], actions: [ { actionOK in
                print("Yes Clicked")
                if let model = self.viewModel, let bookMark = model.bookmarkedData?[indexPath.row] {
                    model.deleteBookMarkData(bookMark: bookMark)
                    self.mainTableView.reloadSections(IndexSet(integer: 1), with: .fade)
                }
            }, { actionCancel in
                print("No Clicked")
            }])
        })
        delete.backgroundColor = .appBlueColor
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}

extension MainViewController {
    @IBAction func changeLocation(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLocationVCID") as? ChangeLocationVC {
            controller.delegate = self
            let navigationControl = WFNavigationController(rootViewController: controller)
            navigationControl.modalPresentationStyle = .fullScreen
            self.present(navigationControl, animated: true, completion: nil)
        }
    }
    
    @IBAction func moveToHelp(_ sender: Any) {
        if let helpController = self.storyboard?.instantiateViewController(withIdentifier: "HelpViewControllerID") as? HelpViewController {

            let navigationControl = WFNavigationController(rootViewController: helpController)
            navigationControl.modalPresentationStyle = .fullScreen
            self.present(navigationControl, animated: true, completion: nil)
        }
    }
}

extension MainViewController: SearchVCDelegate {
    func reloadTableWithNewData() {
        DispatchQueue.main.async {
            self.reloadDataAndTable()
        }
    }
}
