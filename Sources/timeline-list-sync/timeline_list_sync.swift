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
    public private(set) var text = "Hello, World!"
    private static let apiKey = ProcessInfo.processInfo.environment["TWITTER_API_KEY"]
    private static let apiSecret = ProcessInfo.processInfo.environment["TWITTER_API_SECRET"]
    private static let accessToken = ProcessInfo.processInfo.environment["TWITTER_ACCESS_TOKEN"]
    private static let accessTokenSecret = ProcessInfo.processInfo.environment["TWITTER_ACCESS_TOKEN_SECRET"]
    
    
    public static func main() {
        print(TimelineListSync().text)

        let client = TwitterAPIClient(.oauth10a(.init(
            consumerKey: apiKey!,
            consumerSecret: apiSecret!,
            oauthToken: accessToken!,
            oauthTokenSecret: accessTokenSecret!
        )))
    }
}
