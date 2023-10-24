//
//  GitUser.swift
//  RepoWatcher
//
//  Created by Charles Roberts on 10/18/23.
//

import Foundation

struct GitUser: Decodable {
    let avatar_url: String
    let name: String
    let public_repos: Int
    let followers: Int
    let updated_at: String
    
    static let mock = GitUser(
        avatar_url: "",
        name: "cjroberts2013",
        public_repos: 97,
        followers: 12,
        updated_at: "2018-01-14T04:33:35Z"
    )
}


// Working call
// curl -L \
//  -H "Accept: application/vnd.github+json" \
//  -H "Authorization: Bearer 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" \
//  -H "X-GitHub-Api-Version: 2022-11-28" \
//  https://api.github.com/users/cjroberts2013
