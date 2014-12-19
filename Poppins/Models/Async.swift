class Async {
    private var _done: (() -> ())?

    class func map<U, T>(u: [U], f: U -> T) -> Async {
        var proc = Async()
        let queue = AsyncQueue(name: "PoppinsSyncQueue", maxOperations: 10)

        u.map { x in
            queue.addOperationWithBlock { _ = f(x) }
        }

        queue.finally { _ = proc._done?() }

        return proc
    }

    func done(f: () -> ()) {
        _done = f
    }
}
