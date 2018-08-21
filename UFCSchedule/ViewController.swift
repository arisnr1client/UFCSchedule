//
//  ViewController.swift
//  UFCSchedule
//
//  Created by Jay on 8/17/18.
//  Copyright © 2018 Andrzej Baruk. All rights reserved.
//

import UIKit
import ParallaxHeader

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventsTableView: UITableView!
    let cellReuseIdentifier = "eventsCell"
    var ufcEvents: [UFCEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        APICaller.getUFCEventFights()
        
        ufcEvents = APICaller.getUFCEvents(completion: { ufcEvents in
            let tempEvents = ufcEvents
                .filter({ return ($0.eventDate! >= Date.init() && $0.eventStatus == "FINALIZED") })
            return tempEvents
            })
        
        ufcEvents.sort(by: { $0.eventDate! < $1.eventDate! })
        
        self.eventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arena")
        imageView.contentMode = .scaleAspectFill
        
        eventsTableView.parallaxHeader.view = imageView
        eventsTableView.parallaxHeader.height = 100
        eventsTableView.parallaxHeader.minimumHeight = 0
        eventsTableView.parallaxHeader.mode = .topFill
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ufcEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.eventsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        
        cell.textLabel?.text = self.ufcEvents[indexPath.row].subTitle
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     //   let destination = EventDetailsViewController()
       // destination.ufcEvent = ufcEvents[indexPath.row]
        //navigationController?.pushViewController(destination, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController")
        (controller as! EventDetailsViewController).ufcEvent = ufcEvents[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }


}


