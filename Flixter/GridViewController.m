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


@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *moviesArray;
@property (nonatomic, strong) NSArray *filteredMoviesArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation GridViewController

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
        [refreshControl beginRefreshing];

        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=9017031209ee56001d137e43569ed1cf"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error != nil) {
                   NSLog(@"%@", [error localizedDescription]);
                   [refreshControl endRefreshing];
                   
                   // No Internet Error
                   if (error.code == -1009) {
                       UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                      message:@"The internet connection appears to be offline."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                       UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                                                                             handler:^(UIAlertAction * action) {[self beginRefresh:refreshControl];}];
                        
                       [alert addAction:defaultAction];
                       [self presentViewController:alert animated:YES completion:nil];
                   }
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
                   
                   // TODO: Get the array of movies
                   self.moviesArray = dataDictionary[@"results"];
                   self.filteredMoviesArray = self.moviesArray;
                   for (int i = 0; i < self.moviesArray.count; i++)
                       NSLog(@"%@", self.moviesArray[i][@"title"]);
                   // TODO: Store the movies in a property to use elsewhere
                   // TODO: Reload your table view data
                   [self.collectionView reloadData];
                   
                   // TODO: Remove refresh
                   [refreshControl endRefreshing];
               }
           }];
        [task resume];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"https://image.tmdb.org/t/p/w500", self.filteredMoviesArray[indexPath.item][@"poster_path"]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [cell.movieImage setImageWithURL:url];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMoviesArray.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            NSString *lowercaseTitle = evaluatedObject[@"title"];
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
    NSDictionary *dataToPass = self.filteredMoviesArray[[self.collectionView indexPathForCell:sender].item];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end
