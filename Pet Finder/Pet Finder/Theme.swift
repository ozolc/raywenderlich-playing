//
//  Theme.swift
//  Pet Finder
//
//  Created by Maksim Nosov on 09/01/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit

enum Theme: Int {
  // 1
  case defaultTheme, dark, graphical
  
  // 2
  private enum Keys {
    static let selectedTheme = "SelectedTheme"
  }
  
  // 3
  static var current: Theme {
    let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
    return Theme(rawValue: storedTheme) ?? .defaultTheme
  }
  
  var mainColor: UIColor {
    switch self {
    case .defaultTheme:
      return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    case .dark:
      return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    case .graphical:
      return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)    
    }
  }
  
}
