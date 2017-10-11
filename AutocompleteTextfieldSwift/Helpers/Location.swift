//
//  Location.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/22/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    class func geocodeAddressString(_ address:String, completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error == nil {
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        print(placemarks)
                        completion((placemarks[0]), nil)
                    }
                }
            }
            else{
                completion(nil, error as NSError?)
            }
        })
    }
    
    class func reverseGeocodeLocation(_ location:CLLocation,completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let err = error{
                print("Error Reverse Geocoding Location: \(err.localizedDescription)")
                completion(nil, error! as NSError)
                return
            }
            completion(placemarks?[0], nil)
            
        })
    }
    
    class func addressFromPlacemark(_ placemark:CLPlacemark)->String{
        var address = ""
        
        if let name = placemark.addressDictionary?["Name"] as? String {
            address = constructAddressString(address, newString: name)
        }
        
        if let city = placemark.addressDictionary?["City"] as? String {
            address = constructAddressString(address, newString: city)
        }
        
        if let state = placemark.addressDictionary?["State"] as? String {
            address = constructAddressString(address, newString: state)
        }
        
        if let country = placemark.country{
            address = constructAddressString(address, newString: country)
        }
        
        return address
    }
    
    fileprivate class func constructAddressString(_ string:String, newString:String)->String{
        var address = string
        if !address.isEmpty{
            address = address + ", \(newString)"
        }
        else{
            address = address + newString
        }
        return address
    }
}
