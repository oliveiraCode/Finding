//
//  DetailsViewController.swift
//  FindingApp
//
//  Created by Leandro Oliveira on 2019-01-18.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Cosmos

class DetailsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var cvRating: CosmosView!
    @IBOutlet weak var lbReviews: UILabel!
    @IBOutlet weak var lbHourDay0: UILabel!
    @IBOutlet weak var lbHourDay1: UILabel!
    @IBOutlet weak var lbHourDay2: UILabel!
    @IBOutlet weak var lbHourDay3: UILabel!
    @IBOutlet weak var lbHourDay4: UILabel!
    @IBOutlet weak var lbHourDay5: UILabel!
    @IBOutlet weak var lbHourDay6: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbIsOpenNow: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    //MARK - Properties
    private var businessDetails:BusinessDetails?
    var businessIdSelected:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBusinessesData()
       
    }
    
    //MARK - Update UI
    func updateUIWithData(){
        
        //set pageControl's number
        if self.businessDetails?.photos?.count == nil || self.businessDetails?.photos?.count == 0 {
            pageControl.numberOfPages = 1
        } else {
            pageControl.numberOfPages =  (self.businessDetails?.photos?.count)!
        }
        
        //Name
        if self.businessDetails?.name == "" {
            lbName.text = DetailsDefault.unavailable
        }else {
            lbName.text = self.businessDetails?.name
        }
        
        //Rating
        cvRating.rating =  Double(self.businessDetails?.rating ?? 0)
        
        //Review
        guard let review = self.businessDetails?.review_count else {return}
        
        if review == 0 || review == 1 {
            lbReviews.text = "\(review) \(DetailsDefault.review)"
        } else {
            lbReviews.text = "\(review) \(DetailsDefault.reviews)"
        }
        
        //Phone
        if self.businessDetails?.display_phone == "" {
            lbPhone.text = DetailsDefault.unavailable
        }else {
            lbPhone.text = self.businessDetails?.display_phone
        }
        
        //Address
        tvAddress.text = ""
        for value in (self.businessDetails?.location?.display_address?.enumerated())!{
            tvAddress.text += "\(value.element)\n"
        }
        
        //Category
        lbCategory.text = ""
        for value in (self.businessDetails?.categories.enumerated())! {
            lbCategory.text = lbCategory.text! + "\(value.element.title!), "
        }
        
        //Check if is open or not
        guard let is_open_now = self.businessDetails?.hours?[0].is_open_now else {
            lbIsOpenNow.text = DetailsDefault.unavailable
            lbIsOpenNow.textColor = UIColor.red
            return}
        if !is_open_now {
            lbIsOpenNow.text = DetailsDefault.closed
            lbIsOpenNow.textColor = UIColor.red
        }
        
        //Hour day for each week's day
        lbHourDay0.text = setHourBusiness(day: 0)
        lbHourDay1.text = setHourBusiness(day: 1)
        lbHourDay2.text = setHourBusiness(day: 2)
        lbHourDay3.text = setHourBusiness(day: 3)
        lbHourDay4.text = setHourBusiness(day: 4)
        lbHourDay5.text = setHourBusiness(day: 5)
        lbHourDay6.text = setHourBusiness(day: 6)
        
    }
    
    func setHourBusiness(day:Int) -> String{
        
        //get the first element of each day of the week.
        guard let dailyHours:DailyHours = self.businessDetails?.hours?[0].open?.filter({$0.day == day}).first else {return DetailsDefault.unavailable}
        
        //offsetBy define in which index the character : will be placed
        var dayStart = dailyHours.start
        dayStart!.insert(":", at: (dayStart?.index((dayStart?.startIndex)!, offsetBy: 2))!)
        
        var dayEnd = dailyHours.end
        dayEnd!.insert(":", at: (dayEnd?.index((dayEnd?.startIndex)!, offsetBy: 2))!)
        
        return "\(dayStart!) - \(dayEnd!)"
        
    }
    
    //MARK - Get data JSON
    func getBusinessesData(){
  
        //set yelpURL to get data with business' id
        let YelpURL = YelpUrl.url_businesses+businessIdSelected!
        
        //set authentication header
        let headers = ["Authorization": "Bearer \(YelpAuthentication.API_KEY)"]
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.request(YelpURL, method: .get, parameters: ["attributes":"deals"], encoding: JSONEncoding.default, headers: headers ).validate().responseJSON { response in
            switch(response.result) {
            case .success:
                guard let dataFromJson = response.data else {return}

                do {
                    self.businessDetails = try JSONDecoder().decode(BusinessDetails.self, from: dataFromJson)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.updateUIWithData() //update UI with all information form JSON
                    }
                }catch {}
                break
            case .failure:
                print(response.result.error!)
                break
            }
        }
    }
    
    //MARK - CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.businessDetails?.photos?.count == nil || self.businessDetails?.photos?.count == 0 {
            return 1
        } else {
            return (self.businessDetails?.photos?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.cellDetails, for: indexPath) as! DetailsCollectionViewCell
        
        //set all images on collection view
        if self.businessDetails?.photos?.count == nil || self.businessDetails?.photos?.count == 0{
            cell.imageBusiness.image = UIImage(named: Placeholders.placeholder_photo)
        } else {
            cell.imageBusiness.kf.setImage(
                with: URL(string: (self.businessDetails?.photos![indexPath.item])!),
                placeholder: UIImage(named: Placeholders.placeholder_photo),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        
        //image corner with some radius
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
    
}
