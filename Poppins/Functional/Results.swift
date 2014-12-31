import LlamaKit

func >>-<A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Success(box): return f(box.unbox)
    case let .Failure(err): return failure(err)
    }
}

func <*><A, B>(f: Result<A -> B>, a: Result<A>) -> Result<B> {
    switch (f, a) {
    case let (.Success(fBox), .Success(aBox)): return success(fBox.unbox(aBox.unbox))
    case let (.Failure(err), _): return failure(err)
    case let (_, .Failure(err)): return failure(err)
    default: return failure(NSError())
    }
}

func <^><A, B>(f: A -> B, a: Result<A>) -> Result<B> {
    switch a {
    case let .Success(box): return success(f(box.unbox))
    case let .Failure(err): return failure(err)
    }
}
