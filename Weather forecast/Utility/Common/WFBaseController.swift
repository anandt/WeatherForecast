//
//  WFBaseController.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//


import UIKit
import CoreLocation
import SystemConfiguration

class WFBaseController: UIViewController {

    var activityView: WFActivityController?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Loading Indicator
extension WFBaseController {
    func createSpinnerView() {
        if activityView == nil {
            activityView = WFActivityController()
        }
        if let activityData = activityView {
            addChild(activityData)
            activityData.view.frame = view.frame
            view.addSubview(activityData.view)
            activityData.didMove(toParent: self)
        }
    }
    func removeSpinnerView() {
        DispatchQueue.main.async {
            self.activityView?.willMove(toParent: nil)
            self.activityView?.view.removeFromSuperview()
            self.activityView?.removeFromParent()
        }
    }
    
}

// MARK: - Alert Methods
extension WFBaseController  {
    func showAlert(title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func showAlertWithAction(title: String?, message: String?, actionTitles: [String?], actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension WFBaseController {
    func showNoInternetConnection() {
        self.showAlert(title: "Alert", message: "Please check your Network Connection.")
    }
}
