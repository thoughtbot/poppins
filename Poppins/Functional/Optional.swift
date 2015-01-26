import LlamaKit

func >>-<T, U>(a: T?, f: T -> U?) -> U? {
    return a.flatMap(f)
}

func <^><T, U>(f: T -> U, a: T?) -> U? {
    return a.map(f)
}

func <*><T, U>(f: (T -> U)?, a: T?) -> U? {
    return a.apply(f)
}

extension Optional {
    func flatMap<U>(f: T -> U?) -> U? {
        switch self {
        case let .Some(x): return f(x)
        case .None: return .None
        }
    }

    func apply<U>(f: (T -> U)?) -> U? {
        switch f {
        case let .Some(fx): return self.map(fx)
        default: return .None
        }
    }

    func toResult() -> Result<T, NSError> {
        switch self {
        case let .Some(x): return success(x)
        case .None: return failure(NSError(domain: "", code: 0, userInfo: .None))
        }
    }
}
