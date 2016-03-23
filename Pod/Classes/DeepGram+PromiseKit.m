//
//  DeepGram+PromiseKit.m
//  Pods
//
//  Created by Peter Meyers on 3/23/16.
//  Copyright (c) 2016 Peter Meyers. All rights reserved.
//

#import "DeepGram+PromiseKit.h"
#import <PromiseKit/PromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@implementation DGClient (PromiseKit)

- (AnyPromise *)getBalanceWithProgress:(nullable void (^)(NSProgress *progress))progress
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self getBalanceWithProgress:progress success:^(NSURLSessionDataTask *task, NSNumber *hours) {
            resolve(hours);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)indexURL:(NSURL *)audioURL
                progress:(nullable void (^)(NSProgress *progress))progress
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self indexURL:audioURL progress:progress success:^(NSURLSessionDataTask *task, NSString *contentID) {
            resolve(contentID);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)statusOfContent:(NSString *)contentID
                       progress:(nullable void (^)(NSProgress *progress))progress
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self statusOfContent:contentID progress:progress success:^(NSURLSessionDataTask *task, NSNumber *indexStatus) {
            resolve(indexStatus);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)matchesInContent:(NSString *)contentID
                       withQuery:(NSString *)query
                         snippet:(BOOL)snippet
                            Nmax:(nullable NSNumber *)Nmax
                   confidenceMin:(nullable NSNumber *)confidenceMin
                        progress:(nullable void (^)(NSProgress *))progress
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self matchesInContent:contentID withQuery:query snippet:snippet Nmax:Nmax confidenceMin:confidenceMin progress:progress success:^(NSURLSessionDataTask *task, NSArray<DGMatch *> *matches) {
            resolve(matches);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)transcriptForContent:(NSString *)contentID
                            progress:(nullable void (^)(NSProgress *progress))progress
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self transcriptForContent:contentID progress:progress success:^(NSURLSessionDataTask *task, NSDictionary<NSNumber *,NSString *> *paragraphsByStartTime) {
            resolve(paragraphsByStartTime);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)searchAllContentWithQuery:(NSString *)query
                                      tag:(nullable NSString *)tag
                                     Nmax:(nullable NSNumber *)Nmax
                            confidenceMin:(nullable NSNumber *)confidenceMin
                                 progress:(nullable void (^)(NSProgress *))progress
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self searchAllContentWithQuery:query tag:tag Nmax:Nmax confidenceMin:confidenceMin progress:progress success:^(NSURLSessionDataTask *task, NSArray<DGMatch *> *matches) {
            resolve(matches);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

@end

NS_ASSUME_NONNULL_END
