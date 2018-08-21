//
//  UFCEventModel.swift
//  UFCSchedule
//
//  Created by Jay on 8/17/18.
//  Copyright © 2018 Andrzej Baruk. All rights reserved.
//

import Foundation

struct UFCEvent {
    var eventId: Int
    var baseTitle: String
    var subTitle: String
    var eventStatus: String
    var eventDate: Date?
    var arena: String
    var location: String
    var ETTime: String = ""
    var localTime: String = ""
    var featuredImage1URL: URL?
    var featuredImage2URL: URL?
    var eventFights: [UFCEventFight] = []
    init(_ dictionary: [String: Any]) {
        self.eventId = dictionary["id"] as? Int ?? 0
        self.baseTitle = dictionary["base_title"] as? String ?? ""
        self.subTitle = dictionary["title_tag_line"] as? String ?? ""
        self.eventStatus = dictionary["event_status"] as? String ?? ""
        self.arena = dictionary["arena"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.ETTime = getETTime(ETPT: dictionary["event_time_text"] as? String ?? "")
        self.featuredImage1URL = URL.init(string: dictionary["feature_image"] as? String ?? "")
        self.featuredImage2URL = URL.init(string: dictionary["secondary_feature_image"] as? String ?? "")
        self.eventDate = getDate(dictionaryDateEntry: dictionary["event_date"] as? String ?? "")
        
        if (ETTime.count > 0)
        {
            self.localTime = getConvertedTime(originTime: ETTime)
        }

}
    func getDate(dictionaryDateEntry date: String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter.date(from: date as String)
    }
    
    func getETTime(ETPT: String) -> String
    {
        if (ETPT.count > 0)
        {
            print(ETPT)
            return String(ETPT.split(separator: "/")[0])
        }
        else
        {
            return ""
        }
    }
    
    func getConvertedTime(originTime: String) -> String {
        
        var dateFormatString = ""
        let originTimeCopy = String(format: originTime)
        if(originTimeCopy.split(separator: ":").count == 2) {
            dateFormatString = "hh:mma"
        }
        else {
            dateFormatString = "ha"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        let date : Date? = dateFormatter.date(from: originTime)
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = dateFormatString
        
        guard let _: Date? = date else {
            let dateString = outputDateFormatter.string(from: date!)
            return dateString
        }
    
        return "N/A"
    }
}

struct UFCEventFight {
    var eventId: Int
    var fightId: Int
    var weightClass: String
    var fighter1Name: String = ""
    var fighter2Name: String = ""
    var fighter1Nickname: String
    var fighter2Nickname: String
    var fighter1Record: String
    var fighter2Record: String
    var fighter1ImageURL: URL?
    var fighter2ImageURL: URL?
    init(_ dictionary: [String: Any]) {
        self.eventId = dictionary["event_id"] as? Int ?? 0
        self.fightId = dictionary["id"] as? Int ?? 0
        self.weightClass = dictionary["fighter1_weight_class"] as? String ?? ""
        self.fighter1Nickname = dictionary["fighter1_nickname"] as? String ?? ""
        self.fighter2Nickname = dictionary["fighter2_nickname"] as? String ?? ""
        self.fighter1Record = dictionary["fighter1record"] as? String ?? ""
        self.fighter2Record = dictionary["fighter2record"] as? String ?? ""
        self.fighter1ImageURL = URL.init(string: dictionary["fighter1_full_body_image"] as? String ?? "")
        self.fighter2ImageURL = URL.init(string: dictionary["fighter2_full_body_image"] as? String ?? "")
        self.fighter1Name = getFullName(firstN: dictionary["fighter1_first_name"] as? String ?? "", lastN: dictionary["fighter1_last_name"] as? String ?? "")
        self.fighter2Name = getFullName(firstN: dictionary["fighter2_first_name"] as? String ?? "", lastN: dictionary["fighter2_last_name"] as? String ?? "")
    }
    
    func getFullName(firstN: String, lastN: String) -> String
    {
        return firstN + " " + lastN
    }
}
