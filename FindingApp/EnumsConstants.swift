//
//  EnumsConstants.swift
//  FindingApp
//
//  Created by Leandro Oliveira on 2019-01-17.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

enum YelpAuthentication {
    static let API_KEY = "r3hYfHmkoKeDFmV7Ujn0P3-n86dT8ivtvE8KuWgct02t_RCZEM2yOrx7BQnJftktOtG6hHOpIr118ydrRCir2JQxFp0D-hBsw-jZ3smpGnxOpoO00kuyNHag6dZBXHYx"
}

enum YelpUrl {
    static let url_search = "https://api.yelp.com/v3/businesses/search"
    static let url_businesses = "https://api.yelp.com/v3/businesses/"
}

enum Coordinates {
    //set coordinates from Montreal - approximate
    static let latitude = 45.5576996
    static let longitude = -74.0104841
}

enum CellIdentifier {
    static let cellRoot = "cellRoot"
    static let cellDetails = "cellDetails"
}

enum Placeholders {
    static let searchByBusiness = "Search by business name"
    static let searchByAddress = "Search by address/city/postal code"
    static let searchByCuisine = "Search by cuisine type"
    static let placeholder_photo = "placeholder_photo"
}

enum IdSegueOnStoryboard {
    static let showDetailVC = "showDetailVC"
}

enum DetailsDefault{
    static let unavailable = "Unavailable"
    static let review = "review"
    static let reviews = "reviews"
    static let closed = "Closed"
}

enum AlertDefault{
    static let titleController = "Oups!"
    static let message = "We did not find anything. How about trying again?"
    static let titleAlertOK = "OK"
}
