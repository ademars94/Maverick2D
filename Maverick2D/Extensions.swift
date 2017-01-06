//
//  Extensions.swift
//  Maverick2D
//
//  Created by Alex DeMars on 1/6/17.
//  Copyright © 2017 Alex DeMars. All rights reserved.
//

import Foundation

extension Date {
  
  func millisecondsSince1970() -> TimeInterval {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "y-MM-dd H:mm:ss.SSSZ"
    
    let nineteenSeventy = dateFormatter.date(from: "1970-01-01 0:00:00.000-0000") ?? date
    let delta = date.timeIntervalSince(nineteenSeventy)
    let formattedDelta = round(delta * 1000)
    
    return formattedDelta
  }
  
}
