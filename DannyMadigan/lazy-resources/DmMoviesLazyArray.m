//
//  DmMoviesLazyArray.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 13/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmMoviesLazyArray.h"

#import "DmRestApi.h"



@interface DmMoviesLazyArray ()

@property (nonatomic) int lastPageLoaded;

@end



@implementation DmMoviesLazyArray

- (instancetype)initWithSearchResults:(DmSearchResults *)searchResults;
{
    self = [super init];
    
    if (self) {
        self.query = searchResults.query;
        self.totalNumberOfMovies = searchResults.totalNumberOfMovies;
        self.movies = [NSArray arrayWithArray:searchResults.movies];
        self.lastPageLoaded = 1;
    }
    
    return self;
}

- (BOOL)canLoadMore
{
    return self.movies.count < self.totalNumberOfMovies;
}

- (void)loadNextPage
{
    int nextPageNumber = self.lastPageLoaded + 1;
    
    [[DmRestApi shared]
     searchBy:self.query
     page:nextPageNumber
     success:^(DmSearchResults * results) {
         self.lastPageLoaded = nextPageNumber;
         [self.movies arrayByAddingObjectsFromArray:results.movies];
         if (self.nextPageLoadedHandler) {
             self.nextPageLoadedHandler(self.movies, results.movies, nil);
         }
     }
     error:^(NSError * error) {
         if (self.nextPageLoadedHandler) {
             self.nextPageLoadedHandler(self.movies, nil, error);
         }
     }];
}

@end
