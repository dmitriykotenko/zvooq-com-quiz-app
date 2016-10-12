//
//  DmRestApi.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmRestApi.h"

#import <AFNetworking.h>

const NSString * DmRestApiResultFormat = @"json";



@interface DmRestApi ()

@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@end




@implementation DmRestApi

+ (instancetype)shared
{
    static DmRestApi * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DmRestApi new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.sessionManager =
        [[AFHTTPSessionManager alloc]
         initWithBaseURL:[NSURL URLWithString:@"https://www.omdbapi.com/"]];
    }
    
    return self;
}

- (void)searchBy:(NSString *)searchQuery
            page:(NSUInteger)page
         success:(void (^)(NSArray *, NSUInteger))successHandler
           error:(void (^)(NSError *))errorHandler
{
    // Todo: custom error domain.
    if (! searchQuery) {
        errorHandler([NSError errorWithDomain:NSURLErrorDomain code:1821 userInfo:@{@"reason": @"Search query can not be nil"}]);
    }
    if (page < 1) {
        errorHandler([NSError errorWithDomain:NSURLErrorDomain code:1822 userInfo:@{@"reason": @"Page must be >= 1"}]);
    }
    
    NSDictionary * params =
    @{
      @"s": searchQuery,
      @"page": [NSNumber numberWithUnsignedLong:page],
      @"r": DmRestApiResultFormat
      };
    
    [self.sessionManager
     GET:@""
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         int total = [responseObject[@"totalResults"] intValue]; //todo: parse total number of movies

         NSMutableArray * movies = [NSMutableArray array];
         NSArray * moviesJson = responseObject[@"Search"];
         
         for(NSDictionary * movieJson in moviesJson) {
             DmMovie * movie = [[DmMovie alloc] initWithJson:movieJson];
             if (movie) {
                 [movies addObject:movie];
             }
         }
         
         successHandler(movies, total);
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         errorHandler(error);
     }];
}

- (void)getMovieById:(NSString *)movieId
             success:(void (^)(NSObject *))successHandler
               error:(void (^)(NSError *))errorHandler
{
    if (! movieId) {
        errorHandler([NSError errorWithDomain:NSURLErrorDomain code:1821 userInfo:@{@"reason": @"Movie ID can not be nil"}]);
    }
    
    NSDictionary * params =
    @{
      @"i": movieId,
      @"r": DmRestApiResultFormat
      };
    
    [self.sessionManager
     GET:@""
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary * movieJson = responseObject;

         successHandler([[DmMovie alloc] initWithJson:movieJson]);
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         errorHandler(error);
     }];
}

@end
