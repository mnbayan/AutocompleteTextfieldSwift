//
//  ViewController.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/21/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    @IBOutlet weak var modelInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextField()
        handleTextFieldInterfaces()
    }
    
    private func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                self?.fetchAutocompleteModels(text)
            }
        }
        
        autocompleteTextfield.onSelect = {[weak self] model , indexpath in
            
            let user = model as! UserModel
            self?.modelInfo.text = "User Id: \(user.userId) \nFName: \(user.firstName) \n LastName: \(user.lastName) "
        }
    }
    
    private func fetchAutocompleteModels(keyword:String) {
        
        var modelsArray  = [AutoCompletionTextProtocol]()
        for i in 0...5 {
            
            let model = UserModel(userId: "\(i)", firstName: "User\(i)", middleName: "", lastName: "Shah")
            modelsArray.append(model)
            }
            
        self.autocompleteTextfield.autoCompleteModels = modelsArray
        }
}


