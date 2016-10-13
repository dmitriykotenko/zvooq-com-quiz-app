//
//  DmMovieCell.h
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DmMovie.h"



@interface DmMovieCell : UICollectionViewCell

// Compute cell's height according to desired width.
+ (CGSize)sizeForWidth:(CGFloat)width;

@property (nonatomic, strong) DmMovie * movie;

@end
