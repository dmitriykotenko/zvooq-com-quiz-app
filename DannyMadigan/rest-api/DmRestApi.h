//
//  DmRestApi.h
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DmMovie.h"
#import "DmSearchResults.h"



extern NSString * DmErrorDomain;



@interface DmRestApi : NSObject

+ (instancetype)shared;

- (void)searchBy:(NSString *)searchQuery
            page:(NSUInteger)page
         success:(void (^)(DmSearchResults * searchResults))successHandler
           error:(void (^)(NSError * error))errorHandler;

- (void)getMovieById:(NSString *)movieId
             success:(void(^)(DmMovie * movie))successHandler
               error:(void(^)(NSError * error))errorHandler;

@end
