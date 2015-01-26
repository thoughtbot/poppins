import LlamaKit

func >>-<T, U, E>(a: Result<T, E>, f: T -> Result<U, E>) -> Result<U, E> {
    return a.flatMap(f)
}

func <^><T, U, E>(f: T -> U, a: Result<T, E>) -> Result<U, E> {
    return a.map(f)
}

func <*><T, U, E>(f: Result<T -> U, E>, a: Result<T, E>) -> Result<U, E> {
    return a.apply(f)
}

extension Result {
    func apply<U>(f: Result<T -> U, E>) -> Result<U, E> {
        switch f {
        case let .Success(fx): return self.map(fx.unbox)
        case let .Failure(e): return failure(e.unbox)
        }
    }
}
