import ReactiveCocoa
import Result
import Runes

class DropboxClient: NSObject, DBRestClientDelegate, SyncClient {
    private let session: DBSession
    private let restClient: DBRestClient
    private let metaSignal = Signal<[FileInfo]>()
//    private let shareURLSignal = Signal<String>()
    private let uploadSignal = Signal<Void>()
//    private var fileSignals: [String:Signal<String>] = [:]
    private var fileSink: SinkOf<Event<String, NSError>>?
    private var shareURLSink: SinkOf<Event<String, NSError>>?

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

    func getFile(path: String, destinationPath: String) -> SignalProducer<String, NSError> {
        return SignalProducer { sink, _ in
            self.restClient.loadFile("/\(path)", intoPath: destinationPath)
            self.fileSink = sink
        }
//        let sig = Signal<String>()
//        fileSignals[path] = sig
//        return sig.finally { _ = self.fileSignals.removeValueForKey(path) }
    }

    func getShareURL(path: String) -> SignalProducer<String, NSError> {
        return SignalProducer { sink, _ in
            self.restClient.loadSharableLinkForFile("/\(path)", shortUrl: false)
            self.shareURLSink = sink
        }
    }

    func uploadFile(filename: String, localPath: String) -> Signal<Void> {
        restClient.uploadFile(filename, toPath: "/", withParentRev: nil, fromPath: localPath)
        return uploadSignal
    }

    func restClient(client: DBRestClient!, loadedFile destPath: String?) {
        curry(sendNext) <^> fileSink <*> destPath
//        fileSink.map(sendCompleted)
//         self.fileSignals[$0.lastPathComponent]?.push($0) }
    }

    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError?) {
        curry(sendError) <^> fileSink <*> error
//        fileSink.map(sendCompleted)
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
        curry(sendError) <^> shareURLSink <*> error
//        shareURLSink.map(sendCompleted)
    }

    func restClient(restClient: DBRestClient!, loadedSharableLink link: String!, forFile path: String!) {
        curry(sendNext) <^> shareURLSink <*> link
//        shareURLSink.map(sendCompleted)
    }

    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        println(error)
        uploadSignal.fail <^> error
    }

    func restClient(client: DBRestClient!, uploadedFile destPath: String!) {
        uploadSignal.push()
    }
}

