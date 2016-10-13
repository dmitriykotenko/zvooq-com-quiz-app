//
//  DmMoviesListViewController.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 11/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "DmMoviesListViewController.h"

#import "DmMovieCell.h"
#import "DmMovieViewController.h"
#import "DmRestApi.h"
#import "DmSearchView.h"



const CGFloat DmMoviesCollectionViewSpacing = 20;
const CGFloat DmMoviesCollectionViewPadding = DmMoviesCollectionViewSpacing;


@interface DmMoviesListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

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
