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

        let list = ProcessInfo.processInfo.environment["TWITTER_LIST_ID"] ?? ""
        let screenName = ProcessInfo.processInfo.environment["TWITTER_SCREEN_NAME"] ?? ""

        let clientManager = ClientManager(
            apiKey: apiKey,
            apiSecret: apiSecret,
            accessToken: accessToken,
            accessTokenSecret: accessTokenSecret
        )

        let client = clientManager.client

        Task.detached {

            do {
                // try await getFollowingUsers(client: client, screenName: screenName)

                let friends = try await getFollowingUsers(client: client, screenName: screenName)

                let listMembers = try await getListMembers(client: client, id: list)
                let users = listMembers.users

                var listIDs: [String] = []

                for user in users {

                    listIDs.append(user.id)
                }


                var ids: [String] = []
                var counter = 0

                for id in friends.ids {

                    if !listIDs.contains(String(id)) {

                        ids.append(String(id))
                        print(id)
                        let res = await client.v1.postAddListMember(.init(list: .listID(list), user: .userID(String(id))))
                            .responseDecodable(type: TwitterListV1.self)

                        if let error = res.error {
                            print(error)
                            break
                        } else {
                            counter += 1
                        }

                        if counter>=50 { break }

                    }

                }
            }



            // try await getList(client: client)
        }

        RunLoop.main.run()
    }
}

func addUsersToList(client: TwitterAPIClient, list: String, users: [String]) async {
    let result = await client.v1.postAddListMembers(.init(list: .listID(list), users: .userIDs(users)))
        .responseDecodable(type: TwitterListV1.self)

    if let error = result.error {
        print(error)
    }else {
        print(result)
    }
}

func getFollowingUsers(client: TwitterAPIClient, screenName: String) async throws -> TwitterFriendsIDsV1 {
    let response = await client.v1.getFriendIDs(.init(user: .screenName(screenName)))
        .responseDecodable(type: TwitterFriendsIDsV1.self)

    if let error = response.error {
        print(error)
        throw error
    } else {
        return response.success!
    }
}

func getList(client: TwitterAPIClient) async throws {
    let response = await client.v1.getLists(.init(user: .userID("petitstb")))
        .responseDecodable(type: [TwitterListV1].self)

    if let error = response.error {
        print(error)
        throw error
    } else {

        for list in response.success! {
            print("\(list.id):  \(list.name), slug: \(list.slug), members: \(list.memberCount)")

        }
    }
}

func getListMembers(client: TwitterAPIClient, id: String) async throws -> TwitterListMembersV1 {
    let listResponse = await client.v1.getList(.init(list: .listID(id))).responseDecodable(type: TwitterListV1.self)

    if let error = listResponse.error {
        print(error)
        throw error
    } else {
        // print(listResponse.success!.memberCount)
        let response = await client.v1.getListMembers(
            .init(list: .listID(id))
        )
            .responseDecodable(type: TwitterListMembersV1.self)

        if let error = response.error {
            print(error)
            throw error
        } else {
            return response.success!
        }
    }


}

struct TwitterListV1: Decodable {
    var id: String
    var slug: String
    var name: String
    var memberCount: Int
    var description: String
    var user: TwitterUserV1

    enum CodingKeys: String, CodingKey {
        case id = "idStr"
        case slug
        case name
        case memberCount
        case description
        case user
    }
}

struct TwitterListMembersV1: Decodable {
    var users: [TwitterUserV1]
}

struct TwitterFriendsIDsV1: Decodable {
    var ids: [Int]
}

struct TwitterStatusV1: Decodable {
    var id: String
    var text: String
    var createdAt: Date
    var user: TwitterUserV1

    enum CodingKeys: String, CodingKey {
        case id = "idStr"
        case text
        case createdAt
        case user
    }
}

struct TwitterUserV1: Decodable {
    var id: String
    var name: String
    var screenName: String
    var createdAt: Date
    var statusesCount: Int

    enum CodingKeys: String, CodingKey {
        case id = "idStr"
        case name
        case screenName
        case createdAt
        case statusesCount
    }
}