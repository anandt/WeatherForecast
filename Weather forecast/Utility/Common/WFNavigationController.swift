//
//  WFNavigationController.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import UIKit

class WFNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationProprites()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    // MARK: - Custom Navigation Proprities
    func setNavigationProprites() {
        UINavigationBar.appearance().barTintColor = UIColor.appBlueColor
        UINavigationBar.appearance().tintColor = UIColor.white
        let color = UIColor.white
        let attrs = [NSAttributedString.Key.foregroundColor: color,
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
}
