//
//  timeline_list_sync.swift
//  TimelineListSync
//
//  Created by petitstrawberry on 2022/09/22
//

import Foundation
import TwitterAPIKit

@main
public struct TimelineListSync {


    public static func main() {
        let apiKey = ProcessInfo.processInfo.environment["TWITTER_CK"] ?? ""
        let apiSecret = ProcessInfo.processInfo.environment["TWITTER_CS"] ?? ""
        let accessToken = ProcessInfo.processInfo.environment["TWITTER_AT"] ?? ""
        let accessTokenSecret = ProcessInfo.processInfo.environment["TWITTER_AS"] ?? ""

        let clientManager = ClientManager(
                                                            apiKey: apiKey,
                                                            apiSecret: apiSecret,
                                                            accessToken: accessToken,
                                                            accessTokenSecret: accessTokenSecret
                                                        )

        let client = clientManager.client.v1


    }
}