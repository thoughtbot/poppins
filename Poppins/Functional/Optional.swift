import LlamaKit

func >>-<A, B>(a: A?, f: A -> B?) -> B? {
    switch a {
    case let .Some(x): return f(x)
    case .None: return .None
    }
}

func <^><A, B>(f: A -> B, a: A?) -> B? {
    return a.map(f)
}

func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
    switch (f, a) {
    case let (.Some(fx), .Some(x)): return fx(x)
    default: return .None
    }
}

extension Optional {
    func toResult() -> Result<T> {
        switch self {
        case let .Some(x): return success(x)
        case .None: return failure(NSError(domain: "", code: 0, userInfo: .None))
        }
    }
}
