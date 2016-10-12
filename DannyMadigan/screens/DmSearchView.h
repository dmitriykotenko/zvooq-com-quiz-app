//
//  DmSearchView.h
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 12/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DmSearchResults.h"

@interface DmSearchView : UIView

// Signal: (query, results, loadingIsInProgress, error)
@property (nonatomic, copy) void (^searchDidFinish)(DmSearchResults * results, NSError * error);

@end
