//
//  DrinkViewController.swift
//  FoodTracker
//
//  Created by Petar Georgiev on 10/18/16.
//  Copyright © 2016 Petar Georgiev. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   // MARK: Properties
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var photoImageView: UIImageView!
   @IBOutlet weak var ratingControl: RatingControl!
   @IBOutlet weak var saveButton: UIBarButtonItem!
   
   
   /*
    This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
   var drink: Drink?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Handle the text field's user input through delegate callbacks.
      nameTextField.delegate = self
      
      // Set up views if editing an existing Meal.
      if let drink = drink {
         navigationItem.title = drink.name
         nameTextField.text   = drink.name
         photoImageView.image = drink.photo
         ratingControl.rating = drink.rating
      }
      
      // Enable the Save button only if the text field has a valid Meal name.
      checkValidDrinkName()
   }
   
   // MARK: Navigation
   @IBAction func cancelDrink(_ sender: UIBarButtonItem) {
      print("In cancel drink")
      
      // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
      let isPresentingInAddDrinkMode = presentingViewController is UINavigationController
      
      if isPresentingInAddDrinkMode {
         print("In true")
         dismiss(animated: true, completion: nil)
      }
      else {
         print("In false")
         navigationController!.popViewController(animated: true)
      }
      
      print("outside if")
      dismiss(animated: true, completion: nil)
   }
   
   // This method lets you configure a view controller before it's presented.
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if saveButton === sender as AnyObject? {
         let name = nameTextField.text ?? ""
         let photo = photoImageView.image
         let rating = ratingControl.rating
         
         // Set the meal to be passed to MealTableViewController after the unwind segue.
         drink = Drink(name: name, photo: photo, rating: rating)
      }
   }
   
   // MARK: Actions
   
   @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
      // Hide the keyboard
      nameTextField.resignFirstResponder()
      
      // UIImagePickerController is a view controller that lets a user pick media from their photo library.
      let imagePickerController = UIImagePickerController()
      
      // Only allow photos to be picked, not taken.
      imagePickerController.sourceType = .photoLibrary
      
      // Make sure ViewController is notified when the user picks an image.
      imagePickerController.delegate = self
      
      present(imagePickerController, animated: true, completion: nil)
   }
   
   // MARK: UITextFieldDelegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      // Hide the keyboard
      textField.resignFirstResponder()
      
      return true
   }
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      // Disable the Save button while editing.
      saveButton.isEnabled = false
   }
   
   func checkValidDrinkName() {
      // Disable the Save button if the text field is empty.
      let text = nameTextField.text ?? ""
      saveButton.isEnabled = true
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      checkValidDrinkName()
      navigationItem.title = textField.text
   }
   
   // MARK: UIImagePickerControllerDelegate
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      // Dismiss the picker if the user canceled.
      dismiss(animated: true, completion: nil)
   }
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      // The info dictionary contains multiple representations of the image, and this uses the original.
      let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
      
      // Set photoImageView to display the selected image.
      photoImageView.image = selectedImage
      
      // Dismiss the picker.
      dismiss(animated: true, completion: nil)
   }
}
