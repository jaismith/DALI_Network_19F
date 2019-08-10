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

    func getMembers(completion: @escaping ([Member]?) -> ()) {
        session.request(URL(string: "http://dali-network-19f.appspot.com/api/members")!, method: .get)
            .validate(statusCode: [200])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data, let members = try? JSONDecoder().decode([Member].self, from: data) else {
                        os_log("Error fetching members: deserialization failed", log: OSLog.default, type: .error)
                        return
                    }

                    completion(members.sorted(by: {memberA, memberB in return memberA.name < memberB.name}))

                case .failure(let error):
                    os_log("Error fetching members: %@", log: OSLog.default, type: .error, error.localizedDescription)
                }
        }
    }
}
