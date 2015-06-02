import Foundation
import Result

extension Optional {
    func toResult() -> Result<T, NSError> {
        switch self {
        case let .Some(x): return .success(x)
        case .None: return .failure(NSError(domain: "", code: 0, userInfo: .None))
        }
    }
}
