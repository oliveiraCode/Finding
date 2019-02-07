//
//  RootTableViewController.swift
//  FindingApp
//
//  Created by Leandro Oliveira on 2019-01-17.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Cosmos

class RootViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    //MARK - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    //MARK - Properties
    var businessArray:[BusinessBasic]?
    var allBusinessJSON:AllBusinessesInfo_JSON?
    var indexPathId:Int!
    let activityIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActivityIndicatorValues()
    }
    
    
    //MARK - Methods Segmented Control
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        //set the placeholder on searchBar
        switch sender.selectedSegmentIndex {
        case 0:
            searchBar.placeholder = Placeholders.searchByBusiness
            break
        case 1:
            searchBar.placeholder = Placeholders.searchByAddress
            break
        case 2:
            searchBar.placeholder = Placeholders.searchByCuisine
            break
        default:
            break
        }
    }
    
    //MARK - Methods SearchBar
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder() //close the keyboard
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // user starts a new search
        self.businessArray?.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //show the cancel button and get the results from JSON
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.resignFirstResponder()
        getBusinessesData()
    }
    
    
    func getStringWhenTypeSearchBar() -> String{
        //original url + ?, it means to receive some parameters
        var stringTyped = YelpUrl.url_search+"?"
        
        //addingPercentEncoding is to write correctly our URL
        let userTyped = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        //set url with parameters by categories business or address or cuisine
        switch categorySegmentedControl.selectedSegmentIndex {
        case 0: //business
            stringTyped += "&term=\(userTyped)"
            stringTyped += "&latitude=\(LocationManagerService.shared.currentLocation.coordinate.latitude)&longitude=\(LocationManagerService.shared.currentLocation.coordinate.longitude)"
            break
        case 1: //address
            stringTyped += "&location=\(userTyped)"
            break
        case 2: //cuisine
            stringTyped += "&categories=\(userTyped.lowercased())"
            stringTyped += "&latitude=\(LocationManagerService.shared.currentLocation.coordinate.latitude)&longitude=\(LocationManagerService.shared.currentLocation.coordinate.longitude)"
            break
        default:
            break
        }
        
        // sort by distance or rating
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: //distance
            stringTyped += "&sort_by=distance"
            break
        case 1: //rating
            stringTyped += "&sort_by=rating"
            break
        default:
            break
        }
        
        return stringTyped
    }
    
    //MARK - Activity Indicator
    func setActivityIndicatorValues(){
        
        //set an style
        activityIndicator.style = .gray
        
        // Position of activity indicator in the center of the main view
        activityIndicator.center = view.center
        
        // Hiding activity indicator when stopAnimating() is called
        activityIndicator.hidesWhenStopped = true
        
        //Add activity indicator to main view
        view.addSubview(activityIndicator)
        
    }
    //MARK - Get data JSON
    func getBusinessesData(){
        
        // Start Activity Indicator
        activityIndicator.startAnimating()
        
        //set yelpURL to get data with user's options
        let YelpURL = getStringWhenTypeSearchBar()
        
        //set authentication header
        let headers = ["Authorization": "Bearer \(YelpAuthentication.API_KEY)"]
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.request(YelpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            switch(response.result) {
            case .success:
                guard let dataFromJson = response.data else {return}
                do {
                    self.allBusinessJSON = try JSONDecoder().decode(AllBusinessesInfo_JSON.self, from: dataFromJson)
                    DispatchQueue.main.async {
                        
                        //result is empty or not
                        if  (self.allBusinessJSON?.businesses?.count)! <= 0 {
                            //call method alert to show alert message
                            self.displayAlert(titleController: AlertDefault.titleController, message: AlertDefault.message, titleAlert: AlertDefault.titleAlertOK)
                        } else {
                            //update tableview with values
                            self.businessArray = self.allBusinessJSON?.businesses
                            self.tableView.reloadData()
                        }
                        
                        // Stop Activity Indicator
                        self.activityIndicator.stopAnimating()
                    }
                }catch {}
                break
            case .failure:
                print(response.result.error!)
                break
            }
        }
    }
    
    //MARK - Alert Message
    func displayAlert(titleController:String, message:String,titleAlert:String){
        
        let alert = UIAlertController.init(title: titleController, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return businessArray?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cellRoot , for: indexPath) as! RootTableViewCell
        
        cell.imgBusiness.kf.setImage(
            with: URL(string: (self.businessArray?[indexPath.row].image_url)!),
            placeholder: UIImage(named: Placeholders.placeholder_photo),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.lbName.text = self.businessArray?[indexPath.row].name
        cell.lbPrice.text = self.businessArray?[indexPath.row].price
        cell.lbDistance.text = String(format: "%.2f km", (self.businessArray?[indexPath.row].distance)!/1000)
        cell.vRating.rating = Double((self.businessArray?[indexPath.row].rating)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPathId = indexPath.row
        performSegue(withIdentifier: IdSegueOnStoryboard.showDetailVC, sender: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdSegueOnStoryboard.showDetailVC {
            let vc = segue.destination as! DetailsViewController
            vc.businessIdSelected = (self.businessArray?[indexPathId].id)!
        }
    }
    
    
}


