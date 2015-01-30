import LlamaKit
import Runes

class Signal<T> {
    private var observer: (Result<T, NSError> -> ())? = .None
    private var final: (() -> ())? = .None
    var filter: T -> T? = { $0 }

    func observe(observer: Result<T, NSError> -> ()) -> Signal<T> {
        self.observer = observer
        return self
    }

    func finally(f: () -> ()) -> Signal<T> {
        final = f
        return self
    }

    func push(t: T) {
        observer?(filter(t).toResult())
        final?()
    }

    func fail(error: NSError) {
        observer?(failure(error))
    }
}
