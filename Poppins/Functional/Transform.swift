func transform<T, U>(f: T throws -> U) -> T -> U? {
    return { x in
        do {
            return try f(x)
        } catch {
            return .None
        }
    }
}
