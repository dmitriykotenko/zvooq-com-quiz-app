//
//  DmSearchView.h
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 12/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DmSearchResults.h"
#import "DmMoviesLazyArray.h"


@interface DmSearchView : UIView

- (NSString *)currentQuery;

// Signal: (query, results, loadingIsInProgress, error)
@property (nonatomic, copy) void (^searchQueryDidChange)(NSString * currentQuery);
@property (nonatomic, copy) void (^searchDidFinish)(DmMoviesLazyArray * moviesLazyArray, NSError * error);

- (void)hideKeyboard;

@end
