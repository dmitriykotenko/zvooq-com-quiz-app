//
//  DmMoviesLazyArray.h
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 13/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DmSearchResults.h"



@interface DmMoviesLazyArray : NSObject

@property (nonatomic, strong) NSString * query;
@property (nonatomic) int totalNumberOfMovies;
@property (nonatomic, strong) NSArray * movies;

@property (nonatomic) BOOL canLoadMore;
@property (nonatomic, copy) void (^nextPageLoadedHandler)(NSArray * allMovies, NSArray * lastPage, NSError * error);

- (instancetype)initWithSearchResults:(DmSearchResults *)searchResults;

- (void)loadNextPage;

@end
