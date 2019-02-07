//
//  BusinessBasic.swift
//  FindingApp
//
//  Created by Leandro Oliveira on 2019-01-18.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

//used in search results
struct BusinessBasic:Codable {
    let id: String?
    let name: String?
    let image_url: String?
    let title: String?
    let price: String?
    let rating: Float?
    let distance: Float?
}

//returned by search made by user
struct AllBusinessesInfo_JSON: Codable {
    let businesses: [BusinessBasic]?
}
