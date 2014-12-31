import LlamaKit

func >>-<A, B>(a: A?, f: A -> B?) -> B? {
    return a.flatMap(f)
}

func <^><A, B>(f: A -> B, a: A?) -> B? {
    return a.map(f)
}

func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
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
        switch (self, f) {
        case let (.Some(x), .Some(fx)): return fx(x)
        default: return .None
        }
    }

    func toResult() -> Result<T> {
        switch self {
        case let .Some(x): return success(x)
        case .None: return failure(NSError(domain: "", code: 0, userInfo: .None))
        }
    }
}
