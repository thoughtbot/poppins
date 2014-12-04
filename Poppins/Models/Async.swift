class Async {
    private var _done: (() -> ())?

    class func map<U, T>(u: [U], f: U -> T) -> Async {
        var proc = Async()
        let dispatch_queue = dispatch_queue_create("com.poppins.cache", DISPATCH_QUEUE_CONCURRENT)
        let dispatch_group = dispatch_group_create()

        u.map { x in
            dispatch_group_async(dispatch_group, dispatch_queue) { _ = f(x) }
        }

        dispatch_group_notify(dispatch_group, dispatch_queue) { _ = proc._done?() }

        return proc
    }

    func done(f: () -> ()) {
        _done = f
    }
}
