//
//  GMSUserAddedPlace.h
//  Google Places API for iOS
//
//  Copyright 2016 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

NS_ASSUME_NONNULL_BEGIN;

/**
 * Represents a place constructed by a user, suitable for adding to Google's collection of places.
 *
 * All properties must be set before passing to GMSPlacesClient.addPlace, except that either website
 * _or_ phoneNumber may be nil.
 *
 * NOTE: The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down
 * on June 30, 2018, and will no longer be available after that date.
 */
__GMS_AVAILABLE_BUT_DEPRECATED_MSG(
    "The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down on "
    "June 30, 2018, and will no longer be available after that date.")
@interface GMSUserAddedPlace : NSObject

/** Name of the place. */
@property(nonatomic, copy, nullable) NSString *name __GMS_AVAILABLE_BUT_DEPRECATED_MSG(
    "The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down on "
    "June 30, 2018, and will no longer be available after that date.");

/** Address of the place. */
@property(nonatomic, copy, nullable) NSString *address __GMS_AVAILABLE_BUT_DEPRECATED_MSG(
    "The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down on "
    "June 30, 2018, and will no longer be available after that date.");

/** Location of the place. */
@property(nonatomic, assign) CLLocationCoordinate2D coordinate __GMS_AVAILABLE_BUT_DEPRECATED_MSG(
    "The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down on "
    "June 30, 2018, and will no longer be available after that date.");

/** Phone number of the place. */
@property(nonatomic, copy, nullable) NSString *phoneNumber __GMS_AVAILABLE_BUT_DEPRECATED_MSG(
    "The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down on "
    "June 30, 2018, and will no longer be available after that date.");

/** List of types of the place as an array of NSStrings, like the GMSPlace.types property.
* Only <a href="/places/ios-api/supported_types#table1">table 1 types</a>
* are valid.
*/
@property(nonatomic, copy, nullable) NSArray<NSString *> *types __GMS_AVAILABLE_BUT_DEPRECATED_MSG(
    "The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down on "
    "June 30, 2018, and will no longer be available after that date.");

/** The website for the place. */
@property(nonatomic, copy, nullable) NSString *website __GMS_AVAILABLE_BUT_DEPRECATED_MSG(
    "The Add Place feature is deprecated as of June 30, 2017. This feature will be turned down on "
    "June 30, 2018, and will no longer be available after that date.");

@end

NS_ASSUME_NONNULL_END;
