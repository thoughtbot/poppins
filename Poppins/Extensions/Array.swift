func safeValue<T>(array: [T], index: Int) -> T? {
    return array.safeValue(index)
}

extension Array {
    func safeValue(index: Int) -> T? {
        return (startIndex..<endIndex).contains(index) ? self[index] : .None
    }
}

func compact<T>(ts: [T?]) -> [T] {
    return ts.reduce([]) { accum, item in item.map { accum + [$0] } ?? accum }
}
