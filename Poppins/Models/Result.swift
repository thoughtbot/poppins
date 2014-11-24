public enum Result<A> {
    case Success(Box<A>)
    case Error(NSError)

    public static func success(v: A) -> Result<A> {
        return .Success(Box(v))
    }

    public static func error(v: NSError) -> Result<A> {
        return .Error(v)
    }
}

public final class Box<A> {
    let _value: A

    init(_ v: A) {
        _value = v
    }
}
