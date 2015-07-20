struct Keys {
  static var dropboxKey: String {
    return NSBundle.mainBundle().infoDictionary?["DropboxKey"] as? String ?? ""
  }

  static var dropboxSecret: String {
    return NSBundle.mainBundle().infoDictionary?["DropboxSecret"] as? String ?? ""
  }
}
