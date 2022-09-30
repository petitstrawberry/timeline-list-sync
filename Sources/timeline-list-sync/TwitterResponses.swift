import Foundation

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