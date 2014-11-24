func >>-<A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Success(aBox): return f(aBox._value)
    case let .Error(err): return .error(err)
    }
}

func <*><A, B>(f: Result<A -> B>, a: Result<A>) -> Result<B> {
    switch (f, a) {
    case let (.Success(fBox), .Success(aBox)): return .success(fBox._value(aBox._value))
    case let (.Error(err), _): return .error(err)
    case let (_, .Error(err)): return .error(err)
    default: return .error(NSError())
    }
}

func <^><A, B>(f: A -> B, a: Result<A>) -> Result<B> {
    switch a {
    case let .Success(aBox): return .success(f(aBox._value))
    case let .Error(err): return .error(err)
    }
}
