//
//  JourneysViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

class JourneysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JourneyCellDelegate {
    
    private let journeysViewModel = JourneysViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor.lightBlue()
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
        
        let goal = journeysViewModel.journeys.value[indexPath.row].desc
        
        let alertVC = UIAlertController(title: "Rozpoczynasz wyprawę", message: "Twoim celem jest wpłacenie \(goal) na cel Fundacji. Startujemy?", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Zapłon!", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        let noAction = UIAlertAction(title: "Jednak nie", style: .destructive, handler: nil)
        
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        
        present(alertVC, animated: true)
        
    }
    
    func didTapEdit(journey: Journey) {
        configure(journey: journey)
    }
    
    
}
