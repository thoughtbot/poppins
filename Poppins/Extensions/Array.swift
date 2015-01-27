func safeValue<T>(array: [T], index: Int) -> T? {
    if contains(array.startIndex..<array.endIndex, index) {
        return array[index]
    } else {
        return .None
    }
}
