//
//  MKMapViewExtension.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/22/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//

import Foundation
import MapKit


let MERCATOR_OFFSET = 268435456.0
let MERCATOR_RADIUS = 85445659.44705395
let DEGREES = 180.0

extension MKMapView{
  //MARK: Map Conversion Methods
  private func longitudeToPixelSpaceX(longitude:Double)->Double{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / DEGREES)
  }
  
  private func latitudeToPixelSpaceY(latitude:Double)->Double{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * M_PI / DEGREES)) / (1 - sin(latitude * M_PI / DEGREES))) / 2.0)
  }
  
  private func pixelSpaceXToLongitude(pixelX:Double)->Double{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * DEGREES / M_PI
    
  }
  
  private func pixelSpaceYToLatitude(pixelY:Double)->Double{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * DEGREES / M_PI
  }
  
  private func coordinateSpanWithCenterCoordinate(centerCoordinate:CLLocationCoordinate2D, zoomLevel:Double)->MKCoordinateSpan{
    
    // convert center coordiate to pixel space
    let centerPixelX = longitudeToPixelSpaceX(centerCoordinate.longitude)
    let centerPixelY = latitudeToPixelSpaceY(centerCoordinate.latitude)
    
    // determine the scale value from the zoom level
    let zoomExponent:Double = 20.0 - zoomLevel
    let zoomScale:Double = pow(2.0, zoomExponent)
    
    // scale the map’s size in pixel space
    let mapSizeInPixels = self.bounds.size
    let scaledMapWidth = Double(mapSizeInPixels.width) * zoomScale
    let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
    
    // figure out the position of the top-left pixel
    let topLeftPixelX = centerPixelX - (scaledMapWidth / 2.0)
    let topLeftPixelY = centerPixelY - (scaledMapHeight / 2.0)
    
    // find delta between left and right longitudes
    let minLng = pixelSpaceXToLongitude(topLeftPixelX)
    let maxLng = pixelSpaceXToLongitude(topLeftPixelX + scaledMapWidth)
    let longitudeDelta = maxLng - minLng
    
    let minLat = pixelSpaceYToLatitude(topLeftPixelY)
    let maxLat = pixelSpaceYToLatitude(topLeftPixelY + scaledMapHeight)
    let latitudeDelta = -1.0 * (maxLat - minLat)
    
    return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
  }
  
  func setCenterCoordinate(centerCoordinate:CLLocationCoordinate2D, var zoomLevel:Double, animated:Bool){
    // clamp large numbers to 28
    zoomLevel = min(zoomLevel, 28)
    
      // use the zoom level to compute the region
    let span = self.coordinateSpanWithCenterCoordinate(centerCoordinate, zoomLevel: zoomLevel)
    let region = MKCoordinateRegionMake(centerCoordinate, span)
    if region.center.longitude == -180.00000000{
      print("Invalid Region")
    }
    else{
      self.setRegion(region, animated: animated)
    }
  }
  
}