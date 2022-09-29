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
        let listID = ProcessInfo.processInfo.environment["TWITTER_LIST_ID"] ?? ""
        let screenName = ProcessInfo.processInfo.environment["TWITTER_SCREEN_NAME"] ?? ""

        let clientManager = ClientManager(
            apiKey: apiKey,
            apiSecret: apiSecret,
            accessToken: accessToken,
            accessTokenSecret: accessTokenSecret
        )

        let client = clientManager.client

        Task {
            // リスト指定してなかったら一覧表示
            if listID=="" {
                try await printLists(client: client)
            } else {
                try await removeMemberFromList(client: client, listID: listID, screenName: screenName)
                try await addFriendsIntoList(client: client, listID: listID, screenName: screenName)
            }
        }

        RunLoop.main.run()
    }
}

func printLists(client: TwitterAPIClient) async throws {
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

func addFriendsIntoList(client: TwitterAPIClient, listID: String, screenName: String) async throws {
    let friends = try await getFriends(client: client, screenName: screenName)
    let listMembers = try await getListMembers(client: client, id: listID)

    let users = listMembers.users
    var listedUserIDs: [String] = []
    for user in users {
        listedUserIDs.append(user.id)
    }

    print("Start adding friends into list: \(listID) (\(users.count) members)")

    var count = 0
    for id in friends.ids {

        if !listedUserIDs.contains(String(id)) {

            print("Adding \(String(id))")
            // リストへ追加のリクエスト
            let response = await client.v1.postAddListMember(
                .init(
                    list: .listID(listID),
                    user: .userID(String(id))
                )
            ).responseDecodable(type: TwitterListV1.self)

            if let error = response.error {
                print(error)
                break
            } else {
                print("success! \(response.success!.memberCount) users")
            }

            count += 1
            if count>=100 { break }

            sleep(1)
        }

    }

    print("Added \(count)/ \(friends.ids.count) users")
}

func removeMemberFromList(client: TwitterAPIClient, listID: String, screenName: String) async throws {
    let friends = try await getFriends(client: client, screenName: screenName)
    let listMembers = try await getListMembers(client: client, id: listID)

    let users = listMembers.users
    var listedUserIDs: [Int] = []
    for user in users {
        listedUserIDs.append(Int(user.id)!)
    }

    print("Start removing non-frined members from list: \(listID)")

    var count = 0
    for id in listedUserIDs {

        if !friends.ids.contains(id) {

            print("Removing \(String(id))")
            // リストから削除のリクエスト
            let response = await client.v1.postRemoveListMember(
                .init(
                    list: .listID(listID),
                    user: .userID(String(id))
                )
            ).responseDecodable(type: TwitterListV1.self)

            if let error = response.error {
                print(error)
                break
            } else {
                print("success! \(response.success!.memberCount) users")
            }

            count += 1
            if count>=100 { break }

            sleep(1)
        }

    }

    print("Removed \(count)/ \(listedUserIDs.count) users")
}

func getFriends(client: TwitterAPIClient, screenName: String) async throws -> TwitterFriendsIDsV1 {
    let response = await client.v1.getFriendIDs(
            .init(
                user: .screenName(screenName),
                count: 5000
            )
        )
        .responseDecodable(type: TwitterFriendsIDsV1.self)

    if let error = response.error {
        print(error)
        throw error
    } else {
        return response.success!
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
            .init(
                list: .listID(id),
                count: 5000
            )
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
