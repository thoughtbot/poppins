import LlamaKit

func >>-<A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    return a.flatMap(f)
}

func <^><A, B>(f: A -> B, a: Result<A>) -> Result<B> {
    return a.map(f)
}

func <*><A, B>(f: Result<A -> B>, a: Result<A>) -> Result<B> {
    return a.apply(f)
}

extension Result {
    func apply<U>(f: Result<T -> U>) -> Result<U> {
        switch (self, f) {
        case let (.Success(aBox), .Success(fBox)): return success(fBox.unbox(aBox.unbox))
        case let (.Failure(err), _): return failure(err)
        case let (_, .Failure(err)): return failure(err)
        default: return failure(NSError())
        }
    }
}
