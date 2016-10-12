//
//  DmSearchView.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 12/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmSearchView.h"

#import "DmRestApi.h"



@interface DmSearchView () <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dataLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *searchFailedLabel;
@property (weak, nonatomic) IBOutlet UILabel *noInternetLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

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
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (IBAction)retrySearch:(id)sender
{
    [self search];
}

- (void)search
{
    // Todo: show activity indicator
    // Todo: hide errors and buttons
    // Todo: wait until search is completed
    
    // Todo: cancel previous search.
    self.noInternetLabel.hidden = YES;
    self.searchFailedLabel.hidden = YES;
    self.tryAgainButton.hidden = YES;
    
    [self.dataLoadingIndicator startAnimating];
    
    DmSearchResults * results = [DmSearchResults new];
    results.query = self.searchBar.text;
    
    [[DmRestApi shared]
     searchBy:results.query
     page:1
     success:^(NSArray *films, NSUInteger total) {
        [self.dataLoadingIndicator stopAnimating];
         results.movies = films;
         
         if (self.searchDidFinish) {
             self.searchDidFinish(results, nil);
         }
    }
     error:^(NSError *error) {
        [self.dataLoadingIndicator stopAnimating];
         self.searchFailedLabel.hidden = NO;
         self.searchDidFinish(nil, error);
    }];
}

- (void)internetIsOff
{
    // Todo: cancel current request to the server.
    self.noInternetLabel.hidden = NO;
    [self.dataLoadingIndicator stopAnimating];
    self.tryAgainButton.hidden = YES;
}

- (void)internetIsOn
{
    self.noInternetLabel.hidden = YES;
}

#pragma mark - Search Bar delegate

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    // Todo: throttling.
    NSString * trimmedText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self updateAppearanceWithSearchText:trimmedText];

    if (searchText.length > 0) {
        [self search];
    }
}

- (void)updateAppearanceWithSearchText:(NSString *)searchText
{
    if (searchText.length == 0) {
        self.tryAgainButton.hidden = YES;
    }
}

@end
