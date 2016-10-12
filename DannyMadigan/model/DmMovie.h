//
//  DmMovie.h
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DmMovie : NSObject

- (instancetype)initWithJson:(NSDictionary *)movieJson;

// Primary properties.
@property (nonatomic, strong) NSString * movieId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSURL * posterUrl;

// Secondary properties.
@property (nonatomic) int year;

@property (nonatomic, strong) NSString * rated;
@property (nonatomic, strong) NSString * releasedAt;
@property (nonatomic, strong) NSString * runtime;
@property (nonatomic, strong) NSString * genre;

@property (nonatomic, strong) NSString * director;
@property (nonatomic, strong) NSString * writer;
@property (nonatomic, strong) NSString * actors;

@property (nonatomic, strong) NSString * plot;

@property (nonatomic, strong) NSString * language;
@property (nonatomic, strong) NSString * country;

@property (nonatomic, strong) NSString * awards;
@property (nonatomic) double imdbRating;
@property (nonatomic) int imdbVotes;

@end
