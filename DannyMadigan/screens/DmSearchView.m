//
//  DmSearchView.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 12/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmSearchView.h"

#import <AFNetworking.h>

#import <libkern/OSAtomic.h>

#import "AppDelegate.h"
#import "DmRestApi.h"



@interface DmSearchView () <UISearchBarDelegate>
{
    int32_t _searchVersion;
    int32_t _userIsTypingWatchdog;
}

@property (strong, nonatomic) IBOutlet UIView * mainView;

@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * dataLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel * searchFailedLabel;
@property (weak, nonatomic) IBOutlet UILabel * noInternetLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noInternetPanelConstraint;
@property (weak, nonatomic) IBOutlet UIButton * tryAgainButton;

@property (strong, nonatomic) AFNetworkReachabilityManager * reachabilityManager;

@property (nonatomic) BOOL searchHasSucceeded;

@end



@implementation DmSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _DmSearchView_Init];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self _DmSearchView_Init];
    }
    
    return self;
}

- (void)_DmSearchView_Init
{
    [[NSBundle mainBundle] loadNibNamed:@"DmSearchView" owner:self options:nil];
    
    self.mainView.frame = self.bounds;
    self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.mainView];

    [self stretchMainViewToSelf];
    
    // Subscribe to notifications about network reachability.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reachabilityChangeHandler)
     name:DmNotificationReachabilityHasChanged
     object:nil];
    
    [self reachabilityChangeHandler];
}

- (void)stretchMainViewToSelf
{
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)reachabilityChangeHandler
{
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        [self internetIsOn];
    } else {
        [self internetIsOff];
    }
}

- (NSString *)currentQuery
{
    return [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (IBAction)retrySearch:(id)sender
{
    [self search];
}

- (void)search
{
    self.searchHasSucceeded = NO;

    // Cancel all previous searches.
    int32_t searchVersionSnapshot = OSAtomicIncrement32(&_searchVersion);
    
    // If there is no Internet now, do nothing.
    if (! [AFNetworkReachabilityManager sharedManager].isReachable) {
        return;
    }
    
    self.searchFailedLabel.hidden = YES;
    self.tryAgainButton.hidden = YES;
    
    [self.dataLoadingIndicator startAnimating];
    
    NSString * query = self.searchBar.text;
    
    [[DmRestApi shared]
     searchBy:query
     page:1
     success:^(DmSearchResults * results) {
         // If there is a new search in progress, do nothing.
         if (searchVersionSnapshot != _searchVersion) {
             return;
         }
         
        [self.dataLoadingIndicator stopAnimating];
         self.searchHasSucceeded = YES;
         
         DmMoviesLazyArray * lazyArray = [[DmMoviesLazyArray alloc] initWithSearchResults:results];

         if (self.searchDidFinish) {
             self.searchDidFinish(lazyArray, nil);
         }
    }
     error:^(NSError *error) {
         // If there is a new search in progress, do nothing.
         if (searchVersionSnapshot != _searchVersion) {
             return;
         }
         
        [self.dataLoadingIndicator stopAnimating];
         self.searchFailedLabel.hidden = NO;
         // Do not show 'Try Again' button if there is no internet.
         self.tryAgainButton.hidden = ! [AFNetworkReachabilityManager sharedManager].isReachable;
         self.searchDidFinish(nil, error);
    }];
}

- (void)internetIsOff
{
    self.noInternetPanelConstraint.constant = 1000000;
    
    [self.dataLoadingIndicator stopAnimating];
    self.tryAgainButton.hidden = YES;
}

- (void)internetIsOn
{
    self.noInternetPanelConstraint.constant = 0;
    
    if (! self.searchHasSucceeded) {
        [self retrySearch:self];
    }
}

- (void)hideKeyboard
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Search Bar delegate

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    if (self.searchQueryDidChange) {
        self.searchQueryDidChange(self.currentQuery);
    }
    
    [self updateAppearanceWithSearchText:self.currentQuery];

    // Do not perform any search while the user is typing.
    // Wait at least 2 seconds after the typing is finished.
    int32_t userIsTypingWatchdogSnapshot = OSAtomicIncrement32(&_userIsTypingWatchdog);
    double SearchDelaySeconds = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SearchDelaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (userIsTypingWatchdogSnapshot == _userIsTypingWatchdog) {
            if (self.currentQuery.length > 0) {
                [self search];
            }
        }
    });
}

- (void)updateAppearanceWithSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        self.tryAgainButton.hidden = YES;
    }
}

@end
