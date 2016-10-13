//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Petar Georgiev on 10/8/16.
//  Copyright © 2016 Petar Georgiev. All rights reserved.
//

import UIKit

class RatingControl: UIView {
   // MARK: Properties
   
   var rating = 0 {
      didSet {
         setNeedsLayout()
      }
   }
   var ratingButtons = [UIButton]()
   var spacing = 5
   var stars = 5
   
   // MARK: Initialization
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      let filledStarImage = UIImage(named: "filledStar")
      let emptyStarImage = UIImage(named: "emptyStar")
      
      for _ in 0..<stars {
         let button = UIButton()
         
         button.setImage(emptyStarImage, for: UIControlState())
         button.setImage(filledStarImage, for: .selected)
         button.setImage(filledStarImage, for: [.highlighted, .selected])
         
         button.adjustsImageWhenHighlighted = false
         
         button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown)
         ratingButtons += [button]
         addSubview(button)
      }
   }
   
   override func layoutSubviews() {
      // Set the button's width and height to a square the size of the frame's height.
      let buttonSize = Int(frame.size.height)
      var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
      
      // Offset each button's origin by the length of the button plus spacing.
      for (index, button) in ratingButtons.enumerated() {
         buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
         button.frame = buttonFrame
      }
      updateButtonSelectionStates()
   }
   
   override var intrinsicContentSize : CGSize {
      // Something is wrong with the frame (hight is 1000, should be 44)
      let buttonSize = Int(frame.size.height)
      let width = (buttonSize + spacing) * stars
      
      return CGSize(width: 240, height: 44)
   }
   
   // MARK: Button Action
   func ratingButtonTapped(_ button: UIButton) {
      rating = ratingButtons.index(of: button)! + 1
      
      updateButtonSelectionStates()
   }
   
   func updateButtonSelectionStates() {
      for (index, button) in ratingButtons.enumerated() {
         // If the index of a button is less than the rating, that button should be selected.
         button.isSelected = index < rating
      }
   }
}
