//
//  Location.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/22/15.
//  Copyright (c) 2015 MaiLin. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
  
  class func geocodeAddressString(address:String, completion:(placemark:CLPlacemark?, error:NSError?)->Void){
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
      if error == nil{
        if placemarks.count > 0{
          completion(placemark: (placemarks[0] as? CLPlacemark), error: error)
        }
      }
      else{
        completion(placemark: nil, error: error)
      }
    })
  }
  
  class func reverseGeocodeLocation(location:CLLocation,completion:(placemark:CLPlacemark?, error:NSError?)->Void){
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
      if error != nil{
        println("Error Reverse Geocoding Location: \(error.localizedDescription)")
        completion(placemark: nil, error: error)
        return
      }
      
      let placemark = placemarks[0] as! CLPlacemark
      completion(placemark: placemark, error: nil)
      
    })
  }
  
  class func addressFromPlacemark(placemark:CLPlacemark)->String{
    var address = ""
    let name = placemark.addressDictionary["Name"] as? String
    let city = placemark.addressDictionary["City"] as? String
    let state = placemark.addressDictionary["State"] as? String
    let country = placemark.country
    
    if name != nil{
      address = constructAddressString(address, newString: name!)
    }
    if city != nil{
      address = constructAddressString(address, newString: city!)
    }
    if state != nil{
      address = constructAddressString(address, newString: state!)
    }
    if country != nil{
      address = constructAddressString(address, newString: country!)
    }
    return address
  }
  
  private class func constructAddressString(string:String, newString:String)->String{
    var address = string
    if !address.isEmpty{
      address = address.stringByAppendingString(", \(newString)")
    }
    else{
      address = address.stringByAppendingString(newString)
    }
    return address
  }
}