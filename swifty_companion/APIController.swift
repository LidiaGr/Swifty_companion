//
//  APIController.swift
//  day04
//
//  Created by Lidia Grigoreva on 23.06.2021.
//

import UIKit

class APIController {
    weak var delegate : APIIntra42Delegate?
    let token : String
    
    init(apiDelegate: APIIntra42Delegate?, apiToken: String) {
        self.delegate = apiDelegate
        self.token = apiToken
    }
    
    func findUser(username: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(username)"
                        .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print ("Alert")
                self.delegate?.errorOccured(error: NSError(domain: "https://api.intra.42.fr/v2/users/\(username)", code: (response as! HTTPURLResponse).statusCode , userInfo: ["username": "\(username)"]))
                return
            }
            if let recievedData = data {
                do {
                    let user = try JSONDecoder().decode(User.self, from: recievedData)
                    print(user)
//                    self.searchVisits(userId: user.id)
                } catch let err {
                    print(err)
                }
            }
        }.resume()
    }
    
//    func searchVisits(userId: Int) {
//        let url = URL(string: "https://api.intra.42.fr/v2/locations?filter[user_id]=\(userId)"
//                        .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
//
//        var request = URLRequest(url: url!)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (data, response, error) in
//            if let err = error {
//                print(err)
//                return
//            }
//            guard let response = response as? HTTPURLResponse,
//                  (200...299).contains(response.statusCode) else {
//                print(response!)
//                return
//            }
//            if let recievedData = data {
//                do {
//                    let visit = try JSONDecoder().decode([RawVisit].self, from: recievedData)
//                    let visits = self.convertRawToVisit(raw: visit)
//                    self.delegate?.processData(visits: visits)
//                } catch let err {
//                    print(err)
//                }
//            }
//        }
//
//        task.resume()
//    }
//
//    func convertRawToVisit(raw: [RawVisit]) -> [Visit] {
//        var visits: [Visit] = []
//        for visit in raw {
//            let host = visit.host
//            let begin = visit.begin_at.toDate()!.toString(withFormat: "HH:mm")
//            var end = visit.end_at?.toDate()?.toString(withFormat: "HH:mm")
//            if end == nil {
//                end = "now"
//            }
//            let date = visit.begin_at.toDate()!.toString(withFormat: "d MMMM yyyy EEEE")
//
//            visits.append(Visit(host: host, begin_at: begin, end_at: end!, date: date))
//        }
//        return visits
//    }
}
