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

class Code {
  var code: String?
  var state: String?
  var error: String?
  
  init(urlComponents: URLComponents) {
  if let items = urlComponents.queryItems {
    for queryItem in items {
        if let value = queryItem.value {
          switch queryItem.name {
          case "code":
            code = value
          case "state":
            state = value
          case "error":
            error = value
          default:
            break
          }
        }
      }
    }
  }
}
