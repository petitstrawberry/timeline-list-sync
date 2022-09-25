import Foundation
import TwitterAPIKit

public class ClientManager {

    var client: TwitterAPIClient

    init(apiKey: String, apiSecret: String, accessToken: String, accessTokenSecret: String) {

        client = TwitterAPIClient(.oauth10a(.init(
            consumerKey: apiKey,
            consumerSecret: apiSecret,
            oauthToken: accessToken,
            oauthTokenSecret: accessTokenSecret
        )))
    }
}