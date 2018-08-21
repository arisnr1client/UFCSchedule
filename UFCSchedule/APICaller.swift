//
//  APICaller.swift
//  UFCSchedule
//
//  Created by Jay on 8/17/18.
//  Copyright © 2018 Andrzej Baruk. All rights reserved.
//

import Foundation

class APICaller{
 static let BASE_URL = "http://ufc-data-api.ufc.com/api/"
 static let EVENTS_ENDPOINT = "v3/us/events"
    
    static func getUFCEventFights(by eventId: Int = 653016) -> [UFCEventFight]
    {
        let jsonData = APICaller
            .getJSONData(withEndpoint: EVENTS_ENDPOINT + "/" + String(eventId) + "/fights");
        
        var model = [UFCEventFight]()
        
        for modelItem in jsonData
        {
            let fightItem = UFCEventFight(modelItem)
            model.append(fightItem)
        }
        return model
    }
    
    static func getUFCEvents(completion: (_ tempEvents: [UFCEvent]) -> [UFCEvent] = { _ in  return []}) -> [UFCEvent]
    {
        let jsonData = APICaller.getJSONData(withEndpoint: EVENTS_ENDPOINT)

        var model = [UFCEvent]()
        for modelItem in jsonData
        {
            let eventItem = UFCEvent(modelItem)
            model.append(eventItem)
           // print(eventItem.eventStatus)
        }
        
        let modifiedModel = completion(model)
        if (modifiedModel.count > 0)
        {
            model = modifiedModel
        }
        
        return model
    }
    
    class APICaller{
    
    static func getJSONData(withEndpoint endpoint: String = "") -> [[String: Any]]{
        
        let fullURL = BASE_URL + endpoint
        var request = URLRequest(url: URL(string: fullURL)!)
        request.httpMethod = "GET"
        let sem = DispatchSemaphore(value: 0)
        var json: [[String: Any]] = []
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("error=\(String(describing: error))")
                return
            }
            do {
                json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                sem.signal()
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
        }
        task.resume()
        
        _ = sem.wait(timeout: .distantFuture)
        return json
    }
    }
}

