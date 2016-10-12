//
//  DmMoviesListViewController.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmMoviesListViewController.h"

#import "DmMovieCell.h"
#import "DmRestApi.h"
#import "DmSearchView.h"



const CGFloat DmMoviesCollectionViewSpacing = 20;
const CGFloat DmMoviesCollectionViewPadding = DmMoviesCollectionViewSpacing;


@interface DmMoviesListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet DmSearchView * searchView;
@property (weak, nonatomic) IBOutlet UICollectionView * moviesCollectionView;

@property (nonatomic, strong) NSString * searchQuery;
@property (nonatomic, strong) NSString * lastSearchQuery;
@property (nonatomic, strong) NSArray * movies;

@end



@implementation DmMoviesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupMoviesCollectionView];
    
    self.searchView.searchDidFinish = ^(DmSearchResults * results, NSError * error) {
        if (!error) {
            self.movies = results.movies;
            [self.moviesCollectionView reloadData];
        }
    };
}

- (void)setupMoviesCollectionView
{
    [self.moviesCollectionView registerClass:[DmMovieCell class] forCellWithReuseIdentifier:@"MovieCell"];
    
    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.moviesCollectionView.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(DmMoviesCollectionViewPadding, DmMoviesCollectionViewPadding, DmMoviesCollectionViewPadding, DmMoviesCollectionViewPadding);
    
    layout.minimumLineSpacing = DmMoviesCollectionViewSpacing;
    layout.minimumInteritemSpacing = DmMoviesCollectionViewSpacing;
    
    layout.itemSize = [self movieCellSize];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadData];
}

- (void)loadData
{
    // Todo: show activity indicator.
    
    [[DmRestApi shared]
     searchBy:@"day"
     page:1
     success:^(NSArray *films, NSUInteger total) {
         self.movies = films;
         [self.moviesCollectionView reloadData];
    }
     error:^(NSError *error) {
         [[[UIAlertView alloc]
          initWithTitle:@"Network error"
          message:@"Please try again later"
          delegate:nil
          cancelButtonTitle:@"Dismiss"
          otherButtonTitles:nil] show];
    }];
}

- (CGSize)movieCellSize
{
    double width = ([UIScreen mainScreen].bounds.size.width - 2 * DmMoviesCollectionViewPadding - DmMoviesCollectionViewSpacing) / 2;
    double height = 1.5 * width;
    
    return CGSizeMake(width, height);
}

- (void)showNetworkError
{
    
}

- (void)hideNetworkError
{
    
}

- (void)showDataLoadingIndicator
{
    
}

- (void)hideDataLoadingIndicator
{
    
}

- (void)showLoadingMoreIndicator
{
    
}

- (void)hideLoadingMoreIndicator
{
    
}

#pragma mark - Collection View data source and delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DmMovieCell * cell = [self.moviesCollectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    cell.movie = self.movies[indexPath.row];

    return cell;
}

@end
