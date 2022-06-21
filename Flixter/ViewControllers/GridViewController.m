//
//  GridViewController.m
//  Flixter
//
//  Created by Max Bagatini Alves on 6/16/22.
//

#import "GridViewController.h"
#import "CollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieViewController.h"
#import "DetailsViewController.h"
#import "Movie.h"
#import "MovieApiManager.h"


@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *moviesArray;
@property (nonatomic, strong) NSArray *filteredMoviesArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation GridViewController

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
            self.filteredMoviesArray = self.moviesArray;
            for (int i = 0; i < self.moviesArray.count; i++) {
                Movie *movie = self.moviesArray[i];
                NSLog(@"%@", movie.title);
            }
            
            // TODO: Reload your table view data
            [self.collectionView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    self.collectionView.dataSource = self;
    
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    
    [self beginRefresh:(UIRefreshControl *)refreshControl];

}

- (CollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    Movie *movie = self.filteredMoviesArray[indexPath.item];
    
    [cell.movieImage setImageWithURL:movie.posterUrl];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMoviesArray.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *evaluatedObject, NSDictionary *bindings) {
            NSString *lowercaseTitle = evaluatedObject.title;
            lowercaseTitle = lowercaseTitle.lowercaseString;
            return [lowercaseTitle containsString:searchText.lowercaseString];
        }];
        self.filteredMoviesArray = [self.moviesArray filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredMoviesArray);
        
    }
    else {
        self.filteredMoviesArray = self.moviesArray;
    }
    
    [self.collectionView reloadData];
 
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredMoviesArray = self.moviesArray;
    [self.collectionView reloadData];
}




//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    Movie *dataToPass = self.filteredMoviesArray[[self.collectionView indexPathForCell:sender].item];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.movie = dataToPass;
}


@end
