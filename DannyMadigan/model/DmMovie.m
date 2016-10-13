//
//  DmMovie.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmMovie.h"

@implementation DmMovie

- (instancetype)initWithJson:(NSDictionary *)movieJson
{
    self = [super init];
    
    if (self) {
        self.movieId = movieJson[@"imdbID"];
        self.title = movieJson[@"Title"];
        
        NSString * posterUrlString = movieJson[@"Poster"];
        self.posterUrl = [NSURL URLWithString:posterUrlString];
        self.fullsizedPosterUrl = [self fullSizedPosterUrl:posterUrlString];
        
        
        self.year = [movieJson[@"Year"] intValue];
        
        self.rated = movieJson[@"Rated"];
        self.releasedAt = movieJson[@"Released"];
        self.runtime = movieJson[@"Runtime"];
        self.genre = movieJson[@"Genre"];
        
        self.director = movieJson[@"Director"];
        self.writer = movieJson[@"Writer"];
        self.actors = movieJson[@"Actors"];
        
        self.plot = movieJson[@"Plot"];
        
        self.language = movieJson[@"Language"];
        self.country = movieJson[@"Country"];
        
        self.awards = movieJson[@"Awards"];
        self.imdbRating = [movieJson[@"imdbRating"] doubleValue];
        self.imdbVotes = [movieJson[@"imdbVotes"] intValue];
    }
    
    if (!self.movieId || !self.title || !self.posterUrl) {
        return nil;
    }
    
    return self;
}

- (NSURL *)fullSizedPosterUrl:(NSString *)thumbnailUrlString
{
    NSString * fullsizedUrlString = [thumbnailUrlString stringByReplacingOccurrencesOfString:@"_SX300" withString:@""];
    return [NSURL URLWithString:fullsizedUrlString];
}

@end
