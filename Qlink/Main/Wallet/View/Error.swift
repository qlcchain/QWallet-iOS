// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import Result

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
