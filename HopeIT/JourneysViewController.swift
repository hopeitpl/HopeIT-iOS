//
//  JourneysViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class JourneysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JourneyCellDelegate {
    
    private let journeysViewModel = JourneysViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        applyGradientLayer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return }
        if id == "creator" {
            let vc = segue.destination as! JourneyConfiguratorViewController
            vc.journey.value = sender as? Journey
        }
    }
    
    private func configure(journey: Journey?) {
        performSegue(withIdentifier: "creator", sender: journey)
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        configure(journey: nil)
    }

    @IBAction func didTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeysViewModel.journeys.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journey", for: indexPath) as! JourneyCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.set(journey: journeysViewModel.journeys.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let journey = journeysViewModel.journeys.value[indexPath.row]
        
        let alertVC = UIAlertController(title: "Rozpoczynasz wyprawę", message: "Twoim celem jest wpłacenie \(journey.desc) na cel Fundacji. Startujemy?", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Zapłon!", style: .default) { _ in
            self.post(journey: journey)
        }
        
        let noAction = UIAlertAction(title: "Jednak nie", style: .destructive, handler: nil)
        
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
    func didTapEdit(journey: Journey) {
        configure(journey: journey)
    }
    
    private func post(journey: Journey) {
        let url = "http://\(URLs.apiPrefix)/users/1/goal/"
        let params: Parameters = ["user_id": 1, "target": journey.value, "months": journey.installments, "notify_freq": journey.notificationInterval == .week ? 7 : 30]
        Alamofire.request(url, method: .post, parameters: params,
                          encoding: JSONEncoding.default).responseJSON { response in
                            print(response)
                            if response.result.isSuccess, Utilities.isStatusValid(code: response.response?.statusCode) {
                                self.navigationController?.dismiss(animated: true, completion: {
                                    HUD.flash(.success, delay: 1.0)
                                })
                            } else {
                                HUD.flash(.error, delay: 1.0)
                            }
        }
    }
    
}
