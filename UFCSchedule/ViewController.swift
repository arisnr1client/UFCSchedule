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
    var refreshControl = UIRefreshControl()
    let cellReuseIdentifier = "eventsCell"
    var ufcEvents: [UFCEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //  Pull down to refresh setup
        //
        refreshControl.addTarget(self, action: #selector(refreshView(sender:)), for: UIControlEvents.valueChanged)
        eventsTableView.addSubview(refreshControl)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background_reebok")!)
        
        setupUFCEventData()
        
        self.eventsTableView.register(MyCustomSpacedCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.separatorColor = UIColor.clear
        eventsTableView.tableFooterView = UIView()
        eventsTableView.rowHeight = 100.0
        
        //
        //  Parallax Setup
        //
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arena")
        imageView.contentMode = .scaleAspectFill
        
        eventsTableView.parallaxHeader.view = imageView
        eventsTableView.parallaxHeader.height = 200
        eventsTableView.parallaxHeader.minimumHeight = 0
        eventsTableView.parallaxHeader.mode = .topFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ufcEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MyCustomSpacedCell = self.eventsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomSpacedCell
        
        cell.textLabel?.text = self.ufcEvents[indexPath.row].subTitle
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.layer.borderWidth = 2.0
        cell.textLabel?.layer.borderColor = UIColor.white.cgColor
        cell.textLabel?.layer.cornerRadius = 20
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        
       // cell.layoutMargins = UIEdgeInsets.zero
       // cell.contentView.layoutMargins.top = 20.0
        
        cell.selectionStyle = .none
        
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
    
    @objc func refreshView(sender:AnyObject) {
                DispatchQueue.global(qos: .background).async {
                    self.setupUFCEventData()
                    
                    DispatchQueue.main.async {
                        self.eventsTableView.reloadData()
                    }
        }
       self.refreshControl.endRefreshing()
    }
    
    func setupUFCEventData() {
        
    ufcEvents = APICaller.getUFCEvents(completion: { ufcEvents in
    let tempEvents = ufcEvents
    .filter({ return ($0.eventDate! >= Date.init() && $0.eventStatus == "FINALIZED") })
    return tempEvents
    })
    ufcEvents.sort(by: { $0.eventDate! < $1.eventDate! })
    
    }
    
}

class MyCustomSpacedCell: UITableViewCell{
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 20
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }
}

