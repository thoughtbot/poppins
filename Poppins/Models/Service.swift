public enum Service: Printable {
    case Unconfigured
    case Dropbox

    public var description: String {
        switch self {
        case .Unconfigured: return "Unconfigured"
        case .Dropbox: return "Dropbox"
        }
    }

    init?(string: String?) {
        if let s = string {
            switch s {
            case "Unconfigured": self = .Unconfigured
            case "Dropbox": self = .Dropbox
            default: return nil
            }
        } else {
            return nil
        }
    }
}
