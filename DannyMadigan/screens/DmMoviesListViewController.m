//
//  DmMoviesListViewController.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmMoviesListViewController.h"

#import <libkern/OSAtomic.h>

#import "DmMovieCell.h"
#import "DmMovieViewController.h"
#import "DmRestApi.h"
#import "DmSearchView.h"



const CGFloat DmMoviesCollectionViewSpacing = 20;
const CGFloat DmMoviesCollectionViewPadding = DmMoviesCollectionViewSpacing;


@interface DmMoviesListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (atomic) BOOL loadingIsInProgress;

@property (weak, nonatomic) IBOutlet DmSearchView * searchView;
@property (weak, nonatomic) IBOutlet UICollectionView * moviesCollectionView;

@property (nonatomic, strong) NSString * searchQuery;
@property (nonatomic, strong) NSString * lastSearchQuery;

@property (nonatomic, strong) DmMoviesLazyArray * moviesLazyArray;
@property (nonatomic, strong) NSArray * movies;

@end



@implementation DmMoviesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupMoviesCollectionView];
    
    self.searchView.searchDidFinish = ^(DmMoviesLazyArray * lazyArray, NSError * error) {
        if (!error) {
            self.moviesLazyArray = lazyArray;
            self.movies = lazyArray.movies;
            
            lazyArray.nextPageLoadedHandler = ^(NSArray * allMovies, NSArray * lastPage, NSError * error) {
                // Do nothing if the lazy array has been changed.
                if (!error && (lazyArray == self.moviesLazyArray)) {
                    self.movies = allMovies;
                    [self.moviesCollectionView reloadData];
                }
                // Todo: show error.

                if (lazyArray == self.moviesLazyArray) {
                    self.loadingIsInProgress = NO;
                }
            };

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

- (CGSize)movieCellSize
{
    double width = ([UIScreen mainScreen].bounds.size.width - 2 * DmMoviesCollectionViewPadding - DmMoviesCollectionViewSpacing) / 2;
    
    return [DmMovieCell sizeForWidth:width];
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

#pragma mark - Scroll View delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Hide keyboard once the user began scrolling.
    [self.searchView hideKeyboard];
    
    if (scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height < 100) {
        [self tryToLoadNextPage];
    }
}

- (void)tryToLoadNextPage
{
    if (! self.loadingIsInProgress) {
        self.loadingIsInProgress = YES;
        
        [self.moviesLazyArray loadNextPage];
    }
}

- (void)nextPageIsLoaded
{
    // 1. Show loading indicator
    // 2. Request lazy array for the next page
    // 3. Once the page is loaded, update collection view and hide loading indicator
    // 4. If data loading has failed, show error message.
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DmMovieViewController * movieViewController = [DmMovieViewController new];
    movieViewController.movie = self.movies[indexPath.row];
    
    [self presentViewController:movieViewController animated:YES completion:nil];
}

@end
