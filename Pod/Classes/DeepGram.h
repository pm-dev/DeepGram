//
//  DeepGramClient.h
//  Pods
//
//  Created by Peter Meyers on 3/18/16.
//  Copyright (c) 2016 Peter Meyers. All rights reserved.
//

@import Foundation;
@class AFHTTPSessionManager;
@class DGMatch;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const DGBaseURLString;
extern NSString *const DGErrorDomain;
extern NSString *const DGErrorInfoKey;

typedef NS_ENUM(NSUInteger, DGIndexStatus)
{
    DGIndexStatusInProgress,
    DGIndexStatusDone,
};

/**
 * The object responsible for communicating with the Deep Gram API.
 */
@interface DGClient : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 *  The designated initializer.
 *
 *  @param session An AFNetworking session manager responsible for handling the HTTP requests. Use DGBaseURLString as the manager's base URL.
 *  @param userID Your Deep Gram user ID.
 *
 *  @return An initialized CGClient object.
 */
- (instancetype)initWithHTTPSession:(AFHTTPSessionManager *)session userID:(NSString *)userID NS_DESIGNATED_INITIALIZER;

/**
 *  Check account balance.
 *
 *  @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *  @param success  A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the user's number of hours remaining.
 *  @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 *
 *  @return An object that provides API HTTP request-specific information such as the URL, cache policy, request type, and body data or body stream.
 */
- (NSURLSessionDataTask *)getBalanceWithProgress:(nullable void (^)(NSProgress *progress))progress
                                         success:(nullable void (^)(NSURLSessionDataTask *task, NSNumber *hours))success
                                         failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Submit file to API
 *
 *  @param audioURL The remote audio resource's URL. This value is returned in the success block of -indexURL:.
 *  @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *  @param success  A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the content ID.
 *  @param failure  A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 *
 *  @return An object that provides API HTTP request-specific information such as the URL, cache policy, request type, and body data or body stream.
 */
- (NSURLSessionDataTask *)indexURL:(NSURL *)audioURL
                          progress:(nullable void (^)(NSProgress *progress))progress
                           success:(nullable void (^)(NSURLSessionDataTask *task, NSString *contentID))success
                           failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Check file status.
 *
 *  @param contentID The content ID of the audio resource on Deep Gram. This value is returned in the success block of -indexURL:.
 *  @param progress  A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *  @param success   A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and an NSNumber representation of a DGIndexStatus.
 *  @param failure   A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 *
 *  @return An object that provides API HTTP request-specific information such as the URL, cache policy, request type, and body data or body stream.
 */
- (NSURLSessionDataTask *)statusOfContent:(NSString *)contentID
                                 progress:(nullable void (^)(NSProgress *progress))progress
                                  success:(nullable void (^)(NSURLSessionDataTask *task, NSNumber *indexStatus))success
                                  failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Search through a file.
 *
 *  @param contentID     The content ID of the audio resource on Deep Gram. This value is returned in the success block of -indexURL:.
 *  @param query         The string to search the content with.
 *  @param snippet       Boolean determining whether to include the text matched with the query.
 *  @param Nmax          Maximum number of words in the match
 *  @param confidenceMin value between 0 and 1. Confidence threshold that must be met before allowing a match.
 *  @param progress      A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *  @param success       A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and an array or DGMatch objects.
 *  @param failure       A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 *
 *  @return An object that provides API HTTP request-specific information such as the URL, cache policy, request type, and body data or body stream.
 */
- (NSURLSessionDataTask *)matchesInContent:(NSString *)contentID
                                 withQuery:(NSString *)query
                                   snippet:(BOOL)snippet
                                      Nmax:(nullable NSNumber *)Nmax
                             confidenceMin:(nullable NSNumber *)confidenceMin
                                  progress:(nullable void (^)(NSProgress *progress))progress
                                   success:(nullable void (^)(NSURLSessionDataTask *task, NSArray<DGMatch *> *matches))success
                                   failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Download file transcript.
 *
 *  @param contentID The content ID of the audio resource on Deep Gram. This value is returned in the success block of -indexURL:.
 *  @param progress  A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *  @param success   A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and a dictionary mapping the start time of each paragraph to the paragraph text.
 *  @param failure   A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 *
 *  @return An object that provides API HTTP request-specific information such as the URL, cache policy, request type, and body data or body stream.
 */
- (NSURLSessionDataTask *)transcriptForContent:(NSString *)contentID
                                      progress:(nullable void (^)(NSProgress *progress))progress
                                       success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary<NSNumber *, NSString *> *paragraphsByStartTime))success
                                       failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  The manager responsible for managing HTTP requests to the Deep Gram server.
 */
@property (nonatomic, readonly) AFHTTPSessionManager *session;

/**
 *  Your Deep Gram user ID.
 */
@property (nonatomic, readonly) NSString *userID;

@end


@interface DGClient (Convenience)

- (instancetype)initWithUserID:(NSString *)userID;

@end

/**
 *  Object representing a result from a search match.
 */
@interface DGMatch : NSObject

@property (nonatomic, readonly) NSNumber *startTime;
@property (nonatomic, readonly) NSNumber *endTime;
@property (nonatomic, readonly) NSNumber *confidence;
@property (nonatomic, readonly, nullable) NSString *snippet;

@end

NS_ASSUME_NONNULL_END
