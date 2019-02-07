//
//  BusinessDetails.swift
//  FindingApp
//
//  Created by Leandro Oliveira on 2019-01-19.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

//Business details for Details View
struct BusinessDetails:Codable {
    let id:String?
    let name:String?
    let categories:[Categories]
    let rating:Float?
    let display_phone:String?
    let location:Address?
    let review_count:Int?
    let photos:[String]?
    let hours:[Hours]?
}

//Business Category
struct Categories:Codable{
    let title:String?
}

//Business Address
struct Address:Codable{
    let display_address:[String]?
}

//information for 1 day
struct DailyHours:Codable{
    let is_overnight:Bool?
    let start:String?
    let end:String?
    let day:Int?
}

//hours for week (7 days)
struct Hours:Codable{
    let open:[DailyHours]?
    let is_open_now:Bool?
}






