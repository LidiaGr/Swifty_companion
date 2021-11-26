//
//  Tweet.swift
//  day04
//
//  Created by Lidia Grigoreva on 23.06.2021.
//

import UIKit

struct User: Codable {
    var id:     Int
    var login:  String
    var displayname: String
    var url:    String
    var location: String?
    var wallet: Int
    var correction_point: Int
    var image_url: String
    var cursus_users: [Cursus]
    var projects_users: [Project]
    var campus: [Campus]
}

struct Cursus: Codable {
    var level: Double
    var skills: [Skill]
}

struct Skill: Codable {
    var name: String
    var level: Double
}

struct Project: Codable {
    var final_mark: Int?
    var project: ProjectDetails
    var cursus_ids: [Int]
    var status: String
    var validated: Bool?
  
  enum CodingKeys: String, CodingKey {
    case validated = "validated?"
    case final_mark, project, cursus_ids, status
  }
}

struct ProjectDetails: Codable {
	var id: Int
  var name: String
	var slug: String
	var parent_id: Int?
}

struct Campus: Codable {
    var name: String
}

struct Token: Codable {
  var access_token: String
  var token_type: StringLiteralType
  var expires_in: Int
  var refresh_token: String
  var scope: String
  var created_at: Int
}
