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

@property (weak, nonatomic) IBOutlet UIImageView *posterThumbnailImageView;
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
    [self.posterThumbnailImageView setImageWithURL:self.movie.posterUrl placeholderImage:[UIImage imageNamed:@"PosterPlaceholder"]];
    [self.posterImageView setImageWithURL:self.movie.fullsizedPosterUrl];
    
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
    return [NSString stringWithFormat:@"Year: %d", movie.year];
}

- (NSString *)formatDetailedInfoForMovie:(DmMovie *)movie
{
    return [NSString stringWithFormat:@"Director: %@\nWriter: %@\n\nRated: %@\nRuntime: %@\nGenre: %@\nLanguage: %@\n\nActors: %@\n\nPlot: %@",
            movie.director, movie.writer,
            movie.rated, movie.runtime, movie.genre, movie.language,
            movie.actors, movie.plot];
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
         self.detailedInfoLabel.text = nil;
         self.errorPanelHeightConstraint.constant = DmDefaultErrorPanelHeight;
     }];
}

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
