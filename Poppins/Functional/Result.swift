import Result
import Runes

func <^><T, U, E>(f: T -> U, a: Result<T, E>) -> Result<U, E> {
    return a.map(f)
}

func <*><T, U, E>(f: Result<T -> U, E>, a: Result<T, E>) -> Result<U, E> {
    return a.apply(f)
}

extension Result {
    func apply<U>(f: Result<T -> U, Error>) -> Result<U, Error> {
        switch f {
        case let .Success(fx): return self.map(fx.value)
        case let .Failure(e): return .failure(e.value)
        }
    }
}
