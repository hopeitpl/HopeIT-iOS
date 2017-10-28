//
//  HistoryViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import Alamofire

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var payments = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getHistory), name: Notification.Name("payment_confirm"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getHistory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let payment = payments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "\(payment.amount) \(payment.currency)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from:payment.date)
        cell.detailTextLabel?.text = "\(dateString)"
        cell.selectionStyle = .none
        return cell
    }
    
    @objc private func getHistory() {
        let url = "http://10.99.130.92:8000/payments/1"
        Alamofire.request(url).responseJSON { response in
            print(response)
            if response.result.isSuccess, Utilities.isStatusValid(code: response.response?.statusCode) {
                if let JSON = response.result.value as? [String: [[String: AnyObject]]] {
                    let payments = JSON["payments"]!
                    var array = [Payment]()
                    for payment in payments {
                        let p = Payment(amount: payment["operation_amount"] as! Int, currency: payment["operation_currency"] as! String, date: Date())
                        array.append(p)
                    }
                    self.payments = array
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}
