//
//  EventDetailsViewController.swift
//  UFCSchedule
//
//  Created by Jay on 8/17/18.
//  Copyright © 2018 Andrzej Baruk. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    var ufcEvent: UFCEvent?
    @IBOutlet weak var fightScheduleTextView: UITextView!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var dateLabelView: UILabel!
    @IBOutlet weak var locationLabelView: UILabel!
    @IBOutlet weak var featImage1View: UIImageView!
    @IBOutlet weak var featImage2View: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    var contentViewController : UIViewController?
    
    override func viewDidLoad() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.stackView.setCustomSpacing(50.0, after: self.fightScheduleTextView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background_reebok")!)
        
        DispatchQueue.global(qos: .background).async {
            
            self.ufcEvent!.eventFights = APICaller.getUFCEventFights(by: self.ufcEvent!.eventId)
            var bigText = ""
            for fight in self.ufcEvent!.eventFights
            {
                bigText.append("\(fight.fighter1Name) vs \(fight.fighter2Name) \n\n")
            }
            let dataforImage1 = try? Data(contentsOf: (self.ufcEvent?.featuredImage1URL)!)
            let dataforImage2 = try? Data(contentsOf: (self.ufcEvent?.featuredImage2URL)!)
            DispatchQueue.main.async{
                self.titleLabelView.text = ("\(self.ufcEvent!.baseTitle) \n \(self.ufcEvent!.subTitle)")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.dateLabelView.text = formatter.string(from: self.ufcEvent!.eventDate!)
                
                self.locationLabelView.text = "\(self.ufcEvent!.location) \n \(self.ufcEvent!.arena)"
                self.fightScheduleTextView.text = bigText
                self.fightScheduleTextView.sizeToFit()
                self.featImage1View.image = UIImage(data: dataforImage1!)
                self.featImage2View.image = UIImage(data: dataforImage2!)
                
                let properHeight = (self.navigationController?.navigationBar.frame.height)!
                    + self.containerView.frame.height
                    + self.fightScheduleTextView.frame.height + self.featImage1View.image!.size.height
                    + self.featImage2View.image!.size.height;
                
                print(properHeight)
                self.scrollView.contentSize = CGSize.init(width: 0, height: properHeight)
                self.view.setNeedsDisplay()
            }
        }
    }
    
    // MARK: Container View Setup
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            contentViewController = segue.destination as UIViewController
            
            titleLabelView = (contentViewController?.view.subviews[0])! as! UILabel;
            dateLabelView = (contentViewController?.view.subviews[1])! as! UILabel;
            locationLabelView = (contentViewController?.view.subviews[2])! as! UILabel;
        }
    }
}

