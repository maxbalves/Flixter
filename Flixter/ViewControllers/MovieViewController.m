//
//  MovieViewController.m
//  Flixter
//
//  Created by Max Bagatini Alves on 6/15/22.
//

#import "MovieViewController.h"
#import "movieViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "GridViewController.h"
#import "Movie.h"
#import "MovieApiManager.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *moviesArray;

@end

@implementation MovieViewController


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [refreshControl beginRefreshing];

    // new is an alternative syntax to calling alloc init.
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        [refreshControl endRefreshing];
        if (movies == nil) {
            // Network Error
            if (error.code == -1009) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                               message:@"The internet connection appears to be offline."
                                               preferredStyle:UIAlertControllerStyleAlert];
                 
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self beginRefresh:refreshControl];}];
                 
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } else {
            self.moviesArray = movies;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self beginRefresh:(UIRefreshControl *)refreshControl];

}

- (movieViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    movieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieViewCell" forIndexPath:indexPath];

    cell.movie = self.moviesArray[indexPath.row];
    
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moviesArray.count;
}

// #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(movieViewCell *)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    Movie *dataToPass = self.moviesArray[[self.tableView indexPathForCell:sender].row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.movie = dataToPass;
}


@end
