import LlamaKit

func >>-<T, U>(a: Result<T>, f: T -> Result<U>) -> Result<U> {
    return a.flatMap(f)
}

func <^><T, U>(f: T -> U, a: Result<T>) -> Result<U> {
    return a.map(f)
}

func <*><T, U>(f: Result<T -> U>, a: Result<T>) -> Result<U> {
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
