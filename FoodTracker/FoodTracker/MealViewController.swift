//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
   
    @IBOutlet weak var creationTimeTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
         This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
         or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        creationTimeTextField.text = getCreationTime()
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            creationTimeTextField.text = meal.creationTime
           
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    
    //MARK: Navigation....
    
    //cancel button action.....
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        displayCancelError()
        
    }
    // cancel button....
    func cancel() {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
    
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let creationTime = creationTimeTextField.text ?? ""
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, creationTime:creationTime)
    }
    
    //MARK: Actions
//    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
//        
//        // Hide the keyboard.
//        nameTextField.resignFirstResponder()
//        
//        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
//        let imagePickerController = UIImagePickerController()
//        
//        // Only allow photos to be picked, not taken.
//        imagePickerController.sourceType = .photoLibrary
//        
//        // Make sure ViewController is notified when the user picks an image.
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//  }
    
    //MARK: Private Methods
    private func displayCancelError(){
        let alertController = UIAlertController(title: "Are you sure to give up this edit?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default){
            UIAlertAction in self.cancel()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    private func getCreationTime() -> String {
        let creationTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        //date to string
        return formatter.string(from: creationTime)
    }
    
}

