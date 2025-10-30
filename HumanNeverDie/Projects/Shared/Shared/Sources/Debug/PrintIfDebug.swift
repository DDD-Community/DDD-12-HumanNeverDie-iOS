//
//  printIfDebug.swift
//  Shared
//
//  Created by 김규철 on 10/4/25.
//

import Foundation

public func printIfDebug(_ items: Any...) {
    #if DEBUG
    print(items)
    #endif
}
