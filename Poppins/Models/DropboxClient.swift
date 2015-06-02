import Result
import Runes

class DropboxClient: NSObject, DBRestClientDelegate, SyncClient {
    private let session: DBSession
    private let restClient: DBRestClient
    private let metaSignal = Signal<[FileInfo]>()
    private let shareURLSignal = Signal<String>()
    private var fileSignals: [String:Signal<String>] = [:]

    init(session: DBSession) {
        self.session = session
        restClient = DBRestClient(session: session)
        super.init()
        restClient.delegate = self
    }

    func getFiles() -> Signal<[FileInfo]> {
        restClient.loadMetadata("/")
        return metaSignal
    }

    func getFile(path: String, destinationPath: String) -> Signal<String> {
        restClient.loadFile("/\(path)", intoPath: destinationPath)
        let sig = Signal<String>()
        fileSignals[path] = sig
        return sig.finally { _ = self.fileSignals.removeValueForKey(path) }
    }

    func getShareURL(path: String) -> Signal<String> {
        restClient.loadSharableLinkForFile("/\(path)", shortUrl: false)
        return shareURLSignal
    }

    func restClient(client: DBRestClient!, loadedFile destPath: String?) {
        destPath >>- { self.fileSignals[$0.lastPathComponent]?.push($0) }
    }

    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError?) {
        println(error)
    }

    func restClient(client: DBRestClient!, loadedMetadata metadata: DBMetadata?) {
        let fileMetadata = metadata?.contents as? [DBMetadata]
        let fileInfos: [FileInfo]? = fileMetadata?.map(FileInfo.fromDropboxMetadata)
        fileInfos.map(metaSignal.push)
    }

    func restClient(client: DBRestClient!, loadMetadataFailedWithError error: NSError?) {
        println(error)
        metaSignal.fail <^> error
    }

    func restClient(restClient: DBRestClient!, loadSharableLinkFailedWithError error: NSError!) {
        println(error)
    }

    func restClient(restClient: DBRestClient!, loadedSharableLink link: String!, forFile path: String!) {
        shareURLSignal.push(link)
    }
}
