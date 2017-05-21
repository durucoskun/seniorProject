//
//  File.swift
//  travel
//
//  Created by Duru Coskun on 20/05/2017.
//  Copyright © 2017 Ata Aygen. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
    }
    
    func setIsLoggedn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    
}
