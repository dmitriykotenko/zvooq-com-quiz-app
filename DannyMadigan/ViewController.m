//
//  ViewController.m
//  DannyMadigan
//
//  Created by Dmitry Kotenko on 10/10/2016.
//  Copyright © 2016 Fiasko. All rights reserved.
//

#import "ViewController.h"

#import "DmMoviesListViewController.h"



@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMovies:(id)sender {
    UIViewController * moviesListViewController = [DmMoviesListViewController new];
    
    [self presentViewController:moviesListViewController animated:YES completion:nil];
}

@end
