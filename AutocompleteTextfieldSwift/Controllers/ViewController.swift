//
//  ViewController.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/21/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    fileprivate var responseData:NSMutableData?
    fileprivate var selectedPointAnnotation:MKPointAnnotation?
    fileprivate var dataTask:URLSessionDataTask?
    
    fileprivate let googleMapsKey = "AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4"
    fileprivate let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextField()
        handleTextFieldInterfaces()
    }
    
    fileprivate func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.black
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    fileprivate func handleTextFieldInterfaces() {
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text)
            }
        }
        
        autocompleteTextfield.onSelect = {placeName, placeId, indexpath in
            let placesClient = GMSPlacesClient()
            print(placeName)
            placesClient.lookUpPlaceID(placeId) { (places, error) in
                if error == nil {
                    if let place = places {
                        print(place)
                        print("latitude ", place.coordinate.latitude)
                        print("longitude", place.coordinate.longitude)
                    }
                }
            }
        }
    }

    //MARK: - Private Methods
    fileprivate func addAnnotation(_ coordinate:CLLocationCoordinate2D, address:String?){
        if let annotation = selectedPointAnnotation{
            mapView.removeAnnotation(annotation)
        }
        
        selectedPointAnnotation = MKPointAnnotation()
        selectedPointAnnotation!.coordinate = coordinate
        selectedPointAnnotation!.title = address
        mapView.addAnnotation(selectedPointAnnotation!)
    }
    
    fileprivate func fetchAutocompletePlaces(_ keyword:String) {
        let urlString = "\(baseURLString)?key=\(googleMapsKey)&input=\(keyword)"
        let s = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        s.addCharacters(in: "+&")
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s as CharacterSet) {
            if let url = URL(string: encodedString) {
                let request = URLRequest(url: url)
                dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do{
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                            if let status = result["status"] as? String{
                                if status == "OK"{
                                    if let predictions = result["predictions"] as? NSArray{
                                        var locations = [AutoPlace]()
                                        for dict in predictions as! [NSDictionary]{
                                            let description = dict["description"] as! String
                                            let place_id = dict["place_id"] as! String
                                            let place = AutoPlace(name: description, id: place_id)
                                            locations.append(place)
                                        }
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            self.autocompleteTextfield.autoCompleteStrings = locations
                                        })
                                        return
                                    }
                                }
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.autocompleteTextfield.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }
}


