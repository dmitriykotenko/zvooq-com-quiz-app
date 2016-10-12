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
        
        // Todo: do not clip a poster to 300px width.
        self.posterUrl = [NSURL URLWithString:movieJson[@"Poster"]];
        
        self.year = [movieJson[@"Year"] intValue];
        
        self.rated = movieJson[@"rated"];
        self.releasedAt = movieJson[@"released"];
        self.runtime = movieJson[@"runtime"];
        self.genre = movieJson[@"genre"];
        
        self.director = movieJson[@"director"];
        self.writer = movieJson[@"writer"];
        self.actors = movieJson[@"actors"];
        
        self.plot = movieJson[@"plot"];
        
        self.language = movieJson[@"language"];
        self.country = movieJson[@"country"];
        
        self.awards = movieJson[@"awards"];
        self.imdbRating = [movieJson[@"runtime"] doubleValue];
        self.imdbVotes = [movieJson[@"runtime"] intValue];
    }
    
    if (!self.movieId || !self.title || !self.posterUrl) {
        // Todo: throw exception.
        return nil;
    }
    
    return self;
}

@end
