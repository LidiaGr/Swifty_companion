//
//  APITwitterDelegate.swift
//  day04
//
//  Created by Lidia Grigoreva on 23.06.2021.
//

import Foundation

protocol APIIntra42Delegate: AnyObject {
    func processData(data: User)
    func errorOccured(error: NSError)
}
