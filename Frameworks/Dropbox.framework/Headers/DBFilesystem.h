/* Copyright (c) 2012 Dropbox, Inc. All rights reserved. */

#import "DBAccount.h"
#import "DBFile.h"
#import "DBFileInfo.h"
#import "DBPath.h"
#import "DBSyncStatus.h"

/** Possible values for thumbnail size when opening a thumbnail.  Thumbnails are scaled
 (not cropped) in a way which preserves the original images aspect ratio, to a
 size which fits within a bounding box defined by the size parameter.
 - XS: 32x32
 - S: 64x64
 - M: 128x128
 - L: 640x480
 - XL: 1024x768 */
typedef enum {
    DBThumbSizeXS,
    DBThumbSizeS,
    DBThumbSizeM,
    DBThumbSizeL,
    DBThumbSizeXL,
} DBThumbSize;

/** Possible values for thumbnail format when opening a thumbnail.*/
typedef enum {
    DBThumbFormatJPG,
    DBThumbFormatPNG,
} DBThumbFormat;


/** The filesystem object provides a files and folder view of a user's Dropbox. The most basic
 operations are listing a folder and opening a file, but it also allows you to move, delete, and
 create files and folders.  The filesystem automatically synchronizes changes with the Dropbox
 server in the background.
 <!-- paragraph separator in class docs for appledoc bug -->
 File and folder info for a user's Dropbox is mirrored locally and synced in the background.
 The content of a file is not downloaded until the file is opened, after which it is cached
 locally, up to a configured maximum size (defaulting to 500MB). If the file cache grows beyond
 the maximum size, the least recently used files will be removed from the cache to free space.
 Cached files will never be removed while in use: i.e. when a [`DBFile`](DBFile) is open, or
 when there is an outstanding upload or download, so it is possible for the cache to temporarily
 exceed the limit. The cache size can be set to zero, in which case files are removed from the
 cache as soon as they are no longer in-use.
 <!-- paragraph separator in class docs for appledoc bug -->
 Background syncing will remain active if there are outstanding changes to upload or download,
 if there are open files, or if there are any observers registered for paths. Otherwise, syncing
 will be paused to preserve battery life until you access the filesystem again.
 <!-- paragraph separator in class docs for appledoc bug -->
 A `DBFilesystem` instance is tied to a linked user account, and will be shut down if the account
 is unlinked. In this case, most methods will fail with an error code of `DBErrorAuth`. */
@interface DBFilesystem : NSObject

/** @name Creating a filesystem object */

/** Create a new filesystem object with a linked [account](DBAccount) from the
 [account manager](DBAccountManager).*/
- (id)initWithAccount:(DBAccount *)account;

/** A convienent place to store your app's filesystem */
+ (void)setSharedFilesystem:(DBFilesystem *)filesystem;

/** A convienent place to get your app's filesystem */
+ (DBFilesystem *)sharedFilesystem;


/** @name Getting file information */

/** Returns a list of DBFileInfo objects representing the files contained in the folder at `path`.
 If <completedFirstSync> is false, then this call will block until the first sync completes or an
 error occurs.

 @return An array of DBFileInfo objects if successful, or `nil` if an error occurred.
 */
- (NSArray *)listFolder:(DBPath *)path error:(DBError **)error;

/** Returns the [file info](DBFileInfo) for the file or folder at `path`, or
 `nil` if an error occurred.  If there is no file or folder at `path`, returns
 `nil` and sets `error` to `DBErrorParamsNotFound`.*/
- (DBFileInfo *)fileInfoForPath:(DBPath *)path error:(DBError **)error;


/** @name Operations */

/** Opens an existing file and returns a [file](DBFile) object representing the file at `path`.

 Files are opened at the newest cached version if the file is cached. Otherwise, the file will
 open at the latest server version and start downloading. Check the `status` property of the
 returned file object to determine whether it's cached. Only 1 file can be open at a given path at
 the same time.

 @return The [file](DBFile) object if the file was opened successfully, or `nil` if an error
 occurred.
 */
- (DBFile *)openFile:(DBPath *)path error:(DBError **)error;

/** Creates a new file at `path` and returns a file object open at that path.

 @return The newly created [file](DBFile) object if the file was opened successfuly, or `nil` if an
 error occurred. */
- (DBFile *)createFile:(DBPath *)path error:(DBError **)error;

/** Opens a thumbnail for an existing file and returns a [file](DBFile) object
 representing a thumbnail for the file at `path`.

 Thumbnails are opened at the newest cached version if the thumbnail is cached.
 Otherwise, the thumbnail will open at the latest version and start downloading.
 Check the `status` property of the returned file object to determine whether
 it's cached.

 Thumbnails are generated on the server and cached separately.  When offline
 a thumbnail might be unavailable even if the file contents are available. If
 a file is modified locally, the thumbnail will not be available until its
 upload completes. Check the `thumbExists` property of the file's info to
 find out if a thumbnail is available for download.

 The DBFile object representing a thumbnail is unrelated to any DBFile opened
 on the file itself.  Thumbnails are read-only - any attempt to write will fail.
 It is possible to open multiple thumbnails (for instance, of different sizes)
 on the same path.

 Thumbnails are scaled (not cropped) in a way which preserves the original
 images aspect ratio, to a size which fits within a bounding box defined by the
 size parameter.

 @return The [file](DBFile) object if the thumbnail was opened successfully, or
 `nil` if an error occurred.
 */
- (DBFile *)openThumbnail:(DBPath *)path ofSize:(DBThumbSize)size
                 inFormat:(DBThumbFormat)format error:(DBError **)error;

/** Creates a new folder at `path`.

 @return YES if the folder was created successfully, or NO if an error occurred. */
- (BOOL)createFolder:(DBPath *)path error:(DBError **)error;

/** Deletes the file or folder at `path`.

 @return YES if the file or folder was deleted successfully, or NO if an error occurred. */
- (BOOL)deletePath:(DBPath *)path error:(DBError **)error;

/** Moves a file or folder at `fromPath` to `toPath`.

 @return YES if the file or folder was moved successfully, or NO if an error occurred. */
- (BOOL)movePath:(DBPath *)fromPath toPath:(DBPath *)toPath error:(DBError **)error;

/** Returns a link to the file or folder at `path`, suitable for sharing. The link
 will optionally be shortened using the Dropbox URL shortener.

 If the file or folder was created locally but not yet uploaded, a link will be
 created, and viewing it before the upload is complete will result in a status
 page indicating the pending upload.

 This requires a server request. It will fail if the app is offline. It
 shouldn't be called on the main thread.

 @return the link URL, or `nil` if an error occurred.
 */
- (NSString *)fetchShareLinkForPath:(DBPath *)path shorten:(BOOL)shorten error:(DBError **)error;

/** @name Getting the current state */

/** The [account](DBAccount) object this filesystem was created with. */
@property (nonatomic, readonly) DBAccount *account;

/** When a user's account is first linked, the filesystem needs to be synced with the server before
 it can be used. This property indicates whether the first sync has completed and the filesystem
 is ready to use. */
@property (nonatomic, readonly) BOOL completedFirstSync;

/** Whether the filesystem is currently shut down. The filesystem will shut down if the account
 associated with this filesystem becomes unlinked. */
@property (nonatomic, readonly, getter=isShutDown) BOOL shutDown;

/** The status of background synchronization. */
@property (nonatomic, readonly) DBSyncStatus *status;


/** @name Watching for changes */

/** Add an observer to be notified any time a property of the filesystem changes.

 The block will be called anytime completedFirstSync, shutDown, or status changes. */
- (BOOL)addObserver:(id)observer block:(DBObserver)block;

/** Add an observer to be notified any time the file or folder at `path` changes. */
- (BOOL)addObserver:(id)observer forPath:(DBPath *)path block:(DBObserver)block;

/** Add an observer to be notified any time the folder at `path` changes or a file or folder
 directly contained in `path` changes. */
- (BOOL)addObserver:(id)observer forPathAndChildren:(DBPath *)path block:(DBObserver)block;

/** Add an observer to be notified any time the folder at `path` changes or a file or folder
 contained somewhere beneath `path` changes. */
- (BOOL)addObserver:(id)observer forPathAndDescendants:(DBPath *)path block:(DBObserver)block;

/** Unregister all blocks associated with `observer` from receiving updates. */
- (void)removeObserver:(id)observer;

/** Shuts down the filesystem, which stops all syncing.

 All associated `DBFile`s will be closed.  Changes that were made to files
 before shutdown will be uploaded the next time a `DBFilesystem` is created.

 After this call, the `DBFilesystem` and its `DBFile`s can no longer be used.
 You should get a new `DBFilesystem` via <initWithAccount:>.

 The filesystem will be automatically shut down if the app is unlinked remotely. */
- (void)shutDown;

/** @name Cache Configuration */

/** The current total disk space consumed by files in the cache. */
@property (nonatomic, readonly) unsigned long long fileCacheSize;

/** The configured maximum size of files in the cache.

 Once set, this setting will remain in effect across app restarts. When the cache size
 is lowered, this method will immediately clean up the cache based on the new limit.
 See the [class documentation](DBFilesystem) for more information on cache management. */
@property (nonatomic, assign) unsigned long long maxFileCacheSize;

@end
