//
//  HelpViewController.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLocalHTMLfile()
        self.createNavigationItems()
        self.navigationItem.title = "Help"
    }
    
    func loadLocalHTMLfile() {
        if let url = Bundle.main.url(forResource: "HelpPage", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
extension HelpViewController {
    func createNavigationItems() {
        let cancelItem = UIBarButtonItem(image: UIImage(named: "cancel"), style: .done, target: self, action: #selector(cancelClicked))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    
    @objc func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
