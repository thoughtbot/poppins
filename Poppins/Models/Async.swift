class Async<T> {
    private var _done: (T -> ())?

    class func run<U>(f: U -> T) -> U -> Async<T> {
        return { u in
            var proc = Async<T>()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let data: T = f(u)
                dispatch_async(dispatch_get_main_queue()) {
                    _ = proc._done?(data)
                }
            }
            return proc
        }
    }

    func done(f: T -> ()) {
        _done = f
    }
}
