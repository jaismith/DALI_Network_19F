//
//  API.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/9/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import Foundation
import Alamofire
import os.log

class API {

    // MARK: Properties

    static private(set) var shared = API()
    var session: Alamofire.Session

    let members = ""

    // MARK: Initializers

    init() {
        let config = Alamofire.Session.default.sessionConfiguration
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = Alamofire.Session(configuration: config)
    }

    // MARK: Public Methods

    func getMembers(completion: @escaping ([Member]?) -> Void) {
        guard let url = URL(string: "http://dali-network-19f.appspot.com/api/members") else {
            fatalError()
        }

        session.request(url, method: .get)
            .validate(statusCode: [200])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                var members: [Member]?
                defer {
                    completion(members)
                }

                switch response.result {
                case .success:
                    guard let data = response.data, let deserializedMembers = try? JSONDecoder().decode([Member].self, from: data) else {
                        os_log("Error fetching members: deserialization failed", log: OSLog.default, type: .error)
                        return
                    }

                    members = deserializedMembers.sorted(by: {memberA, memberB in return memberA.name < memberB.name})

                case .failure(let error):
                    os_log("Error fetching members: %@", log: OSLog.default, type: .error, error.localizedDescription)
                }
        }
    }

    func getMember(_ name: String, completion: @escaping (Member?) -> Void) {
        guard var base = URL(string: "http://dali-network-19f.appspot.com/api/members") else {
            return
        }

        session.request(base.appendingPathComponent(name), method: .get)
            .validate(statusCode: [200])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                var member: Member?
                defer {
                    completion(member)
                }

                switch response.result {
                case .success:
                    guard let data = response.data, let deserializedMember = try? JSONDecoder().decode(Member.self, from: data) else {
                        fatalError()
                    }

                    member = deserializedMember

                case .failure(let error):
                    os_log("Error fetching member %@: %@", log: OSLog.default, type: .error, name, error.localizedDescription)
                }
        }
    }

    func getLocation(_ name: String, completion: @escaping (Location?) -> Void) {
        session.request("http://dali-network-19f.appspot.com/api/members/location", method: .get, parameters: ["member": name], encoding: URLEncoding.default)
            .validate(statusCode: [200])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                var location: Location?
                defer {
                    completion(location)
                }

                switch response.result {
                case .success:
                    guard let data = response.data, let deserializedLocation = try? JSONDecoder().decode(Location.self, from: data) else {
                        fatalError()
                    }

                    location = deserializedLocation

                case .failure(let error):
                    os_log("Error fetching home coordinates for member %@: %@", log: OSLog.default, type: .error, name, error.localizedDescription)
                }
        }
    }
}
