//
//  DeepGram+PromiseKit.h
//  Pods
//
//  Created by Peter Meyers on 3/23/16.
//  Copyright (c) 2016 Peter Meyers. All rights reserved.
//

#import "DeepGram.h"
@class AnyPromise;

NS_ASSUME_NONNULL_BEGIN

@interface DGClient (PromiseKit)

/**
 *  Check account balance.
 *
 *  @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *
 *  @return A promise that fulfills with (NSNumber *hours)
 */
- (AnyPromise *)getBalanceWithProgress:(nullable void (^)(NSProgress *progress))progress;

//
/**
 *  Submit file to API
 *
 *  @param audioURL The remote audio resource's URL. This value is returned in the success block of -indexURL:.
 *  @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *
 *  @return A promise that fulfills with (NSString *contentID)
 */
- (AnyPromise *)indexURL:(NSURL *)audioURL
                progress:(nullable void (^)(NSProgress *progress))progress;

//
/**
 *  Check file status.
 *
 *  @param contentID The content ID of the audio resource on Deep Gram. This value is returned in the success block of -indexURL:.
 *  @param progress  A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *
 *  @return A promise that fulfills with (NSNumber *indexStatus)
 */
- (AnyPromise *)statusOfContent:(NSString *)contentID
                       progress:(nullable void (^)(NSProgress *progress))progress;

//
/**
 *  Search through a file.
 *
 *  @param contentID     The content ID of the audio resource on Deep Gram. This value is returned in the success block of -indexURL:.
 *  @param query         The string to search the content with.
 *  @param snippet       Boolean determining whether to include the text matched with the query.
 *  @param Nmax          Maximum number of words in the match.
 *  @param confidenceMin Value between 0 and 1. Confidence threshold that must be met before allowing a match.
 *  @param progress      A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *
 *  @return A promise that fulfills with (NSArray<DGMatch *> *matches)
 */
- (AnyPromise *)matchesInContent:(NSString *)contentID
                       withQuery:(NSString *)query
                         snippet:(BOOL)snippet
                            Nmax:(nullable NSNumber *)Nmax
                   confidenceMin:(nullable NSNumber *)confidenceMin
                        progress:(nullable void (^)(NSProgress *progress))progress;

//
/**
 *  Download file transcript.
 *
 *  @param contentID The content ID of the audio resource on Deep Gram. This value is returned in the success block of -indexURL:.
 *  @param progress  A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 *
 *  @return A promise that fulfills with (NSDictionary<NSNumber *startTime, NSString *paragraph> *paragraphsByStartTime)
 */
- (AnyPromise *)transcriptForContent:(NSString *)contentID
                            progress:(nullable void (^)(NSProgress *progress))progress;

@end

NS_ASSUME_NONNULL_END
