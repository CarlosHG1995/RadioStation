//
//  RadioAPI.swift
//  RadioStation_Carlos
//
//  Created by cmu on 03/05/2020.
//  Copyright © 2020 UPV. All rights reserved.
//

import Foundation
import CoreData
import UIKit
//paso 2 pag 14 item 3
enum RadioAPI {
    static let BaseURL = "https://de1.api.radio-browser.info/"
    static let Format = "json"
    static let TagsURL = "\(BaseURL)\(Format)/tags"
    static let StationsURL = "\(BaseURL)\(Format)/stations/bytag"

    //static func getTags(onComplete: @escaping (([String]) -> Void)) {
    static func getTags(onComplete: @escaping (([Tag]) -> Void)) {
        guard let url = URL(string: TagsURL) else { return }
    print("url \(url)")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                /*guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return }
                guard let jsonArray = jsonResponse as? [[String: Any]] else { return }
                
                var tags = [String]()
                var contador = 0
                for object in jsonArray {
                    guard let name = object["name"] as? String else { return }
                    tags.append(name)
                    contador = contador + 1
                    if contador == 20 {
                      break
                    }
                }*/
                guard let tags = try? JSONDecoder().decode([Tag].self,from:data) else { return }
                onComplete(tags)
            } catch  let error{
                print("error RadioAPI \(error) ")
            }
        }
         .resume()
    }
    
    static func stationsForTagURL(categoryID: String) -> String {
        let retorno = "\(StationsURL)/\(categoryID)"
        print("retorno- \(retorno)")
        return retorno.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    static func getStations(for tag:String, onComplete: @escaping(([Station]) -> Void)) {
        guard let url = URL(string: stationsForTagURL(categoryID: tag)) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            guard let stations = try? JSONDecoder().decode([Station].self, from: data) else { return }
            
            onComplete(stations)
        }.resume()
    }
    
    //pag 58
    static func fetchFavouriteStations() -> [Station]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        let favRequest = NSFetchRequest<StationEntity>(entityName: "StationEntity")
        favRequest.predicate = NSPredicate(format: "isFavorite = %@", NSNumber(booleanLiteral: true))
        
        var favStations: [Station]? = nil
        do {
            let records = try context.fetch(favRequest)
            favStations = records.map { Station(from: $0) }
        } catch let error {
            print(error)
        }
        
        return favStations
    }
}
 
//pag 24 ejercicio declarar un struct Tag
struct Tag: Decodable {
    let name: String
    let stationcount: Int
}

struct Station: Decodable {
    let name: String
    let url_resolved: String
    let favicon: String
    
    init(from stationEntity: StationEntity) {
           self.name = stationEntity.name
           self.url_resolved = stationEntity.streamURL
           self.favicon = stationEntity.imageURL
       }
}
