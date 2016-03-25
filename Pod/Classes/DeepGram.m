//
//  DeepGramClient.m
//  Pods
//
//  Created by Peter Meyers on 3/18/16.
//  Copyright (c) 2016 Peter Meyers. All rights reserved.
//

#import "DeepGram.h"
@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

NSString *const DGBaseURLString = @"https://api.deepgram.com";
NSString *const DGErrorDomain = @"Deep Gram Error Domain";
NSString *const DGErrorInfoKey = @"Deep Gram Error Info";

@interface DGMatch ()

@property (nonatomic, readwrite) NSString *contentID;
@property (nonatomic, readwrite, nullable) NSNumber *startTime;
@property (nonatomic, readwrite, nullable) NSNumber *endTime;
@property (nonatomic, readwrite) NSNumber *confidence;
@property (nonatomic, readwrite, nullable) NSString *snippet;

@end

@implementation DGMatch

- (NSString *)description
{
    NSMutableString *d = [NSStringFromClass([self class]) mutableCopy];
    [d appendFormat:@" - Start Time: %@", self.startTime];
    [d appendFormat:@" - End Time: %@", self.endTime];
    [d appendFormat:@" - Confidence: %@", self.confidence];
    [d appendFormat:@" - Snippet: %@", self.snippet];
    return d;
}

@end

@implementation DGClient {
    AFHTTPSessionManager *_session;
    NSDictionary<NSString *, NSString *> *_userIDParameter;
}

- (instancetype)initWithHTTPSession:(AFHTTPSessionManager *)session userID:(NSString *)userID
{
    self = [super init];
    _userIDParameter = @{@"userID": userID};
    _session = session;
    return self;
}

- (NSURLSessionDataTask *)getBalanceWithProgress:(nullable void (^)(NSProgress *progress))progress
                                         success:(nullable void (^)(NSURLSessionDataTask *, NSNumber *))success
                                         failure:(nullable void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSMutableDictionary *parameters = [_userIDParameter mutableCopy];
    parameters[@"action"] = @"get_balance";
    return [_session POST:@"" parameters:parameters progress:progress success:^(NSURLSessionDataTask *task, NSDictionary * _Nullable JSON) {
        if (![self _checkErrorInJSON:JSON task:task failure:failure] && success) {
            return success(task, JSON[@"balance"]);
        }
    } failure:failure];
}

- (NSURLSessionDataTask *)indexURL:(NSURL *)audioURL
                          progress:(nullable void (^)(NSProgress *progress))progress
                           success:(nullable void (^)(NSURLSessionDataTask *, NSString *))success
                           failure:(nullable void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSMutableDictionary *parameters = [_userIDParameter mutableCopy];
    parameters[@"data_url"] = audioURL.absoluteString;
    parameters[@"action"] = @"index_content";
    return [_session POST:@"" parameters:parameters progress:progress success:^(NSURLSessionDataTask *task, NSDictionary * _Nullable JSON) {
        if (![self _checkErrorInJSON:JSON task:task failure:failure] && success) {
            return success(task, JSON[@"contentID"]);
        }
    } failure:failure];
}


- (NSURLSessionDataTask *)statusOfContent:(NSString *)contentID
                       progress:(nullable void (^)(NSProgress *progress))progress
                        success:(nullable void (^)(NSURLSessionDataTask *, NSNumber *))success
                        failure:(nullable void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSMutableDictionary *parameters = [_userIDParameter mutableCopy];
    parameters[@"action"] = @"get_object_status";
    parameters[@"contentID"] = contentID;
    return [_session POST:@"" parameters:parameters progress:progress success:^(NSURLSessionDataTask *task, NSDictionary * _Nullable JSON) {
        if (![self _checkErrorInJSON:JSON task:task failure:failure] && success) {
            NSString *statusString = JSON[@"status"];
            NSNumber *status = [statusString isEqualToString:@"done"] ? @(DGIndexStatusDone) : @(DGIndexStatusInProgress);
            success(task, status);
        }
    } failure:failure];
}

- (NSURLSessionDataTask *)matchesInContent:(NSString *)contentID
                                 withQuery:(NSString *)query
                                   snippet:(BOOL)snippet
                                      Nmax:(nullable NSNumber *)Nmax
                             confidenceMin:(nullable NSNumber *)confidenceMin
                                  progress:(nullable void (^)(NSProgress *progress))progress
                                   success:(nullable void (^)(NSURLSessionDataTask *, NSArray<DGMatch *> *))success
                                   failure:(nullable void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSMutableDictionary *parameters = [_userIDParameter mutableCopy];
    parameters[@"action"] = @"object_search";
    parameters[@"contentID"] = contentID;
    parameters[@"query"] = query;
    parameters[@"snippet"] = @(snippet);
    NSMutableDictionary *filter = [@{} mutableCopy];
    filter[@"Nmax"] = Nmax;
    filter[@"Pmin"] = confidenceMin;
    parameters[@"filter"] = filter;
    return [_session POST:@"" parameters:parameters progress:progress success:^(NSURLSessionDataTask *task, NSDictionary * _Nullable JSON) {
        if (![self _checkErrorInJSON:JSON task:task failure:failure] && success) {
            NSArray<NSNumber *> *order = JSON[@"N"];
            NSArray<NSString *> * _Nullable snippets = JSON[@"snippet"];
            NSArray<NSNumber *> *confidences = JSON[@"P"];
            NSArray<NSNumber *> *startTimes = JSON[@"startTime"];
            NSArray<NSNumber *> *endTimes = JSON[@"endTime"];
            NSMutableArray *results = [NSMutableArray arrayWithCapacity:order.count];
            for (NSNumber *resultIndex in order) {
                NSUInteger index = resultIndex.unsignedIntegerValue;
                DGMatch *match = [[DGMatch alloc] init];
                match.contentID = contentID;
                match.confidence = confidences[index];
                match.snippet = snippets[index];
                match.startTime = startTimes[index];
                match.endTime = endTimes[index];
                [results addObject:match];
            }
            success(task, results);
        }
    } failure:failure];
}

- (NSURLSessionDataTask *)transcriptForContent:(NSString *)contentID
                                      progress:(nullable void (^)(NSProgress *progress))progress
                                       success:(nullable void (^)(NSURLSessionDataTask *, NSDictionary<NSNumber *, NSString *> *))success
                                       failure:(nullable void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSMutableDictionary *parameters = [_userIDParameter mutableCopy];
    parameters[@"action"] = @"get_object_transcript";
    parameters[@"contentID"] = contentID;
    return [_session POST:@"" parameters:parameters progress:progress success:^(NSURLSessionDataTask *task, NSDictionary * _Nullable JSON) {
        if (![self _checkErrorInJSON:JSON task:task failure:failure] && success) {
            NSArray<NSNumber *> *paragraphStartTimes = JSON[@"paragraphStartTimes"];
            NSArray<NSString *> *paragraphs = JSON[@"paragraphs"];
            NSMutableDictionary<NSNumber *, NSString *> *results = [NSMutableDictionary dictionaryWithCapacity:paragraphs.count];
            [paragraphs enumerateObjectsUsingBlock:^(NSString *paragraph, NSUInteger idx, BOOL *stop) {
                results[paragraphStartTimes[idx]] = paragraph;
            }];
            success(task, results);
        }
    } failure:failure];
}

- (NSURLSessionDataTask *)searchAllContentWithQuery:(NSString *)query
                                                tag:(nullable NSString *)tag
                                               Nmax:(nullable NSNumber *)Nmax
                                      confidenceMin:(nullable NSNumber *)confidenceMin
                                           progress:(nullable void (^)(NSProgress *))progress
                                            success:(nullable void (^)(NSURLSessionDataTask *, NSArray<DGMatch *> *))success
                                            failure:(nullable void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSMutableDictionary *parameters = [_userIDParameter mutableCopy];
    parameters[@"action"] = @"group_search";
    parameters[@"query"] = query;
    parameters[@"tag"] = tag ?: @"*";
    NSMutableDictionary *filter = [@{} mutableCopy];
    filter[@"Nmax"] = Nmax;
    filter[@"Pmin"] = confidenceMin;
    parameters[@"filter"] = filter;
    return [_session POST:@"" parameters:parameters progress:progress success:^(NSURLSessionDataTask *task, NSDictionary * _Nullable JSON) {
        if (![self _checkErrorInJSON:JSON task:task failure:failure] && success) {
            NSArray<NSString *> *contentIDs = JSON[@"contentID"];
            NSArray<NSNumber *> *order = JSON[@"N"];
            NSArray<NSNumber *> *confidences = JSON[@"P"];
            NSMutableArray *results = [NSMutableArray arrayWithCapacity:order.count];
            for (NSNumber *resultIndex in order) {
                NSUInteger index = resultIndex.unsignedIntegerValue;
                DGMatch *match = [[DGMatch alloc] init];
                match.contentID = contentIDs[index];
                match.confidence = confidences[index];
                [results addObject:match];
            }
            success(task, results);
        }
    } failure:failure];
}

- (NSString *)userID
{
    return _userIDParameter.allValues.firstObject;
}

#pragma mark Internal

- (BOOL)_checkErrorInJSON:(nullable NSDictionary *)JSON
                     task:(NSURLSessionDataTask *)task
                  failure:(nullable void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSString *error = JSON[@"error"];
    if (error) {
        if (failure) {
            failure(task, [NSError errorWithDomain:DGErrorDomain code:0 userInfo:@{DGErrorInfoKey: error}]);
        }
        return YES;
    } else {
        return NO;
    }
}

@end

@implementation DGClient (Convenience)

- (instancetype)initWithUserID:(NSString *)userID
{
    self = [self initWithHTTPSession:[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:DGBaseURLString]] userID:userID];
    self.session.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

@end

NS_ASSUME_NONNULL_END
