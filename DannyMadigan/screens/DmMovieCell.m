//
//  DmMovieCell.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmMovieCell.h"

#import <UIImageView+AFNetworking.h>



@interface DmMovieCell ()

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView * posterImageView;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;

@end




@implementation DmMovieCell

+ (CGSize)sizeForWidth:(CGFloat)width
{
    const CGFloat TitleOverhead = 40;
    CGFloat height = width * 1.5 + TitleOverhead;
    
    return CGSizeMake(width, height);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _DmMovieCell_Init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Initialization code
    [self _DmMovieCell_Init];
}

- (void)_DmMovieCell_Init
{
    [[NSBundle mainBundle] loadNibNamed:@"DmMovieCell" owner:self options:nil];
    
    self.mainView.frame = self.bounds;
    self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.mainView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)setMovie:(DmMovie *)movie
{
    _movie = movie;
    
    self.titleLabel.text = movie.title;
    
    // AFNetworking does the following stuff automatically:
    // 1. Set image once the image is loaded.
    // 2. Do not update the image if the movie has been changed after the loading has began.
    [self.posterImageView setImageWithURL:movie.posterUrl placeholderImage:[UIImage imageNamed:@"PosterPlaceholder"]];
}

@end
