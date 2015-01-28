func safeValue<T>(array: [T], index: Int) -> T? {
    return array.safeValue(index)
}

extension Array {
    func safeValue(index: Int) -> T? {
        return contains(startIndex..<endIndex, index) ? self[index] : .None
    }
}
