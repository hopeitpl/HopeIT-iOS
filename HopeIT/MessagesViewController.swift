//
//  MessagesViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import Alamofire

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessages), name: Notification.Name("payment_confirm"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getMessages), name: Notification.Name("message"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMessages()
    }
    
    @objc private func getMessages() {
        tabBarItem.badgeValue = nil
        let url = "http://10.99.130.92:8000/messages/user/1"
        Alamofire.request(url).responseJSON { response in
            print(response)
            if response.result.isSuccess, Utilities.isStatusValid(code: response.response?.statusCode) {
                if let JSON = response.result.value as? [String: [[String: AnyObject]]] {
                    let messages = JSON["messages"]!
                    var array = [Message]()
                    for message in messages {
                        var img: UIImage?
                        if let image = message["picture"] as? String {
                            img = self.convert(base64string: image)
                        }
                        let body = message["body"] as! String
                        let id = message["id"] as! Int
                        let type = message["message_type"] as? String ?? "message"
                        let m = Message(id: id, content: body, picture: img, date: Date(), type: type)
                        array.append(m)
                    }
                    self.messages = array
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func convert(base64string: String) -> UIImage? {
        let decodedData = Data(base64Encoded: base64string, options: .ignoreUnknownCharacters)!
        return UIImage(data: decodedData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let id = segue.identifier else { return }
        if id == "message" {
            let vc = segue.destination as! MessageViewController
            vc.message = sender as! Message
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = message.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from:message.date)
        cell.detailTextLabel?.text = dateString
        cell.imageView?.image = message.picture
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = messages[indexPath.row]
        performSegue(withIdentifier: "message", sender: message)
        
    }
    
    
}
