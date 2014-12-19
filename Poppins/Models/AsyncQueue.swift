class AsyncQueue {
    private let queue = NSOperationQueue()

    init(name: String, maxOperations: Int) {
        queue.name = name
        queue.maxConcurrentOperationCount = maxOperations
    }

    func addOperation(operation: NSOperation) {
        queue.addOperation(operation)
    }

    func addOperationWithBlock(block: () -> ()) {
        queue.addOperationWithBlock(block)
    }

    func finally(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { [unowned self] in
            self.queue.waitUntilAllOperationsAreFinished()
            block()
        }
    }
}
