//
//  Contact.swift
//  Chat App For iOS 10
//
//  Created by MacBook on 11/22/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import Foundation

class Contact {
    
    private var _name = "";
    private var _id = "";
    
    init(id: String, name: String) {
        _id = id;
        _name = name;
    }
    
    var name: String {
        get {
            return _name;
        }
    }

    var id: String {
        return _id;
    }
    
}








































