//
//  Meal.swift
//  FoodTracker
//
//  Created by Petar Georgiev on 10/13/16.
//  Copyright © 2016 Petar Georgiev. All rights reserved.
//

import UIKit

class Meal {
   // MARK: Attributes
   
   var name: String
   var photo: UIImage?
   var rating: Int
   
   // MARK: Initialization
   init?(name: String, photo: UIImage?, rating: Int) {
      self.name = name
      self.photo = photo
      self.rating = rating
      
      // Initialization should fail if there is no name or if the rating is negative.
      if name.isEmpty || rating < 0 {
         return nil
      }
   }
}
