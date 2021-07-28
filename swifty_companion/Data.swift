//
//  Tweet.swift
//  day04
//
//  Created by Lidia Grigoreva on 23.06.2021.
//

import UIKit

struct User: Decodable {
    var id:     Int
    var login:  String
    var url:    String
    var location: String?
    var wallet: Int
    var image_url: String
    var cursus_users: [Cursus]
    var projects_users: [Project]
}

struct Cursus: Decodable {
    var level: Double
    var skills: [Skill]
}

struct Skill: Decodable {
    var name: String
    var level: Double
}

struct Project: Decodable {
    var final_mark: Int?
    var project: ProjectDetails
}

struct ProjectDetails: Decodable {
    var name: String
}
