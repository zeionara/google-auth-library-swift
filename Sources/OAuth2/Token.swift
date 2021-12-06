// Copyright 2019 Google LLC. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import Foundation

extension CodingUserInfoKey {
    static let clientId = CodingUserInfoKey(rawValue: "client_id")!
    static let clientSecret = CodingUserInfoKey(rawValue: "client_secret")!
}

public struct Token : Codable {
  public var AccessToken : String?
  public var TokenType : String?
  public var ExpiresIn : Int?
  public var RefreshToken : String?
  public var Scope : String?
  public var CreationTime : Date?

  private var ClientID: String?
  private var ClientSecret: String?

  enum CodingKeys: String, CodingKey {
    case AccessToken = "access_token"
    case TokenType = "token_type"
    case ExpiresIn = "expires_in"
    case RefreshToken = "refresh_token"
    case Scope = "scope"
    case CreationTime = "creation_time"

    case ClientID = "client_id"
    case ClientSecret = "client_secret"
  }
  
  func save(_ filename: String) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(self)
    try data.write(to: URL(fileURLWithPath: filename))
  }
  
  public init(accessToken: String) {
    self.AccessToken = accessToken
  }
  
  public init(urlComponents: URLComponents, clientId: String? = nil, clientSecret: String? = nil) {
    CreationTime = Date()

    ClientID = clientId
    ClientSecret = clientSecret

    for queryItem in urlComponents.queryItems! {
      if let value = queryItem.value {
        switch queryItem.name {
        case "access_token":
          AccessToken = value
        case "token_type":
          TokenType = value
        case "expires_in":
          ExpiresIn = Int(value)
        case "refresh_token":
          RefreshToken = value
        case "scope":
          Scope = value
        default:
          break
        }
      }
    }
  }

  public init(from decoder: Decoder) {
      let values = try! decoder.container(keyedBy: CodingKeys.self)

      AccessToken = try? values.decode(String.self, forKey: .AccessToken)
      TokenType = try? values.decode(String.self, forKey: .TokenType)
      ExpiresIn = try? values.decode(Int.self, forKey: .ExpiresIn)
      RefreshToken = try? values.decode(String.self, forKey: .RefreshToken)
      Scope = try? values.decode(String.self, forKey: .Scope)
      CreationTime = try? values.decode(Date.self, forKey: .CreationTime)

      // print("Userinfo inside init = \(decoder.userInfo)")

      ClientID = decoder.userInfo[.clientId] as? String
      ClientSecret = decoder.userInfo[.clientSecret] as? String
  }
}

