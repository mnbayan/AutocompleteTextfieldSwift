//
//  UserModel.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mohshin Shah on 24/10/2016.
//  Copyright © 2016 mnbayan. All rights reserved.
//

import Foundation


public class UserModel: AutoCompletionTextProtocol {
    
    /// The user id.
    public let userId: String
    
    /// The user's first name.
    public let firstName: String
    
    /// The user's middle name.
    public let middleName: String
    
    /// The user's last name.
    public let lastName: String
    
    public init(userId: String,
                firstName: String? = nil,
                middleName: String? = nil,
                lastName: String? = nil) {
        self.userId = userId
        self.firstName = firstName!
        self.middleName = middleName!
        self.lastName = lastName!
    }

    /**
     Provides the text to be used in auto completion
     - returns: Autocompletion Text.
     */

    public func autocompletionText() -> String {
        
        return "\(self.firstName) \(self.lastName)"
    }
    
}
