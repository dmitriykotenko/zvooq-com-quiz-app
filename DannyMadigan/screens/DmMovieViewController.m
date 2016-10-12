//
//  DmMovieViewController.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 12/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmMovieViewController.h"

#import <UIImageView+AFNetworking.h>

#import "DmRestApi.h"



const CGFloat DmDefaultErrorPanelHeight = 59;
NSString * DmLoadingDetailedInfoString = @"Loading detailed info...";



@interface DmMovieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView * posterAspectRatioConstraint;

@property (weak, nonatomic) IBOutlet UIImageView * posterImageView;

@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel * detailedInfoLabel;

@property (weak, nonatomic) IBOutlet UIView * errorPanel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * errorPanelHeightConstraint;

@end



@implementation DmMovieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateWithCurrentMovie];
    [self reloadDetailedInfo];
}

- (void)setMovie:(DmMovie *)movie
{
    _movie = movie;

    if (self.isViewLoaded) {
        [self updateWithCurrentMovie];
    }
}

- (void)updateWithCurrentMovie
{
    [self.posterImageView setImageWithURL:self.movie.posterUrl];
    
    self.titleLabel.text = self.movie.title;
    
    self.summaryLabel.text = [self formatSummaryForMovie:self.movie];
    
    if (self.movie.plot) {
        self.detailedInfoLabel.text = [self formatDetailedInfoForMovie:self.movie];
    } else {
        self.detailedInfoLabel.text = DmLoadingDetailedInfoString;
    }
}

- (NSString *)formatSummaryForMovie:(DmMovie *)movie
{
    return [NSString stringWithFormat:@"Year: %d\nDirector: %@\nWriter: %@", movie.year, movie.director, movie.writer];
}

- (NSString *)formatDetailedInfoForMovie:(DmMovie *)movie
{
    return [NSString stringWithFormat:@"Rated: %@\nRuntime: %@\nGenre: %@\n\nActors: %@\n\nPlot: %@\n\nLanguage: %@",
     movie.rated, movie.runtime, movie.genre, movie.actors, movie.plot, movie.language];
}

- (IBAction)reloadDetailedInfo
{
    self.detailedInfoLabel.text = DmLoadingDetailedInfoString;
    
    // Hide error panel while the data is loaded.
    self.errorPanelHeightConstraint.constant = 0;
    
    [[DmRestApi shared]
     getMovieById:self.movie.movieId
     success:^(DmMovie * movie) {
         self.movie = movie;
         [self updateWithCurrentMovie];
     }
     error:^(NSError *error) {
         self.errorPanelHeightConstraint.constant = DmDefaultErrorPanelHeight;
     }];
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
