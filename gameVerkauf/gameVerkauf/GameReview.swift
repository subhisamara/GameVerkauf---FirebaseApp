//
//  GameReview.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 7/12/17.
//
//

class GameReview{
    var reviewerName: String
    var reviewTitle: String
    var reviewContent: String
    var reviewLikes: Int
    var reviewViews: Int
    
    init(reviewerName: String, reviewTitle:String, reviewContent: String, reviewLikes: Int, reviewViews: Int) {
        self.reviewerName = reviewerName
        self.reviewTitle = reviewTitle
        self.reviewContent = reviewContent
        self.reviewLikes = reviewLikes
        self.reviewViews = reviewViews
    }
}
