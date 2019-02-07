# Finding
Using the Yelp Fusion API (https://www.yelp.com/developers/documentation/v3), that app could fetch and display results of local businesses. 

Available on Apple Store -> https://itunes.apple.com/br/app/finding/id1451016232?mt=8

Environment used
    - Xcode 10.1
    - Swift 4.2
    - iOS 12.1.2


Third-party libraries

    Alamofire was used to get the info from Yelp Fusion API
    For more -> https://cocoapods.org/pods/Alamofire

    Kingfisher was used to download all necessary images.
    For more -> https://cocoapods.org/pods/Kingfisher

    Cosmos was used to show the star rating on RootView and DetailsView
    For more -> https://cocoapods.org/pods/Cosmos
    
    
    
    
V2
    
    
General
   Cache option enabled on all images.
   Images with fade transition, it means with animation.
   Images with rounded edges. (corner radius).

Details view
   Added pageControl below CollectionView.
   Image centered on CollectionView.
   Fixed phone field, no information was available when the phone number did not exist.

Root view
   Added ActivityIndicator indicating to wait for the search.
   Added AlertController showing that no results were found.
