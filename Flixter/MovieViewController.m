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


@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *moviesArray;

@end

@implementation MovieViewController

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
                        
                       UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self beginRefresh:refreshControl];}];
                        
                       [alert addAction:defaultAction];
                       [self presentViewController:alert animated:YES completion:nil];
                   }
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
                   
                   // TODO: Get the array of movies
                   self.moviesArray = dataDictionary[@"results"];
                   for (int i = 0; i < self.moviesArray.count; i++)
                       NSLog(@"%@", self.moviesArray[i][@"title"]);
                   // TODO: Store the movies in a property to use elsewhere
                   // TODO: Reload your table view data
                   [self.tableView reloadData];
                   
                   // TODO: Remove refresh
                   [refreshControl endRefreshing];
               }
           }];
        [task resume];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"https://image.tmdb.org/t/p/w500", self.moviesArray[indexPath.row][@"poster_path"]];

    NSURL *url = [NSURL URLWithString:urlString];
    
    [cell.imageMovieView setImageWithURL:url];
    cell.movieSynopsisLabel.text = self.moviesArray[indexPath.row][@"overview"];
    cell.movieTitleLabel.text = self.moviesArray[indexPath.row][@"title"];
    
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
    NSDictionary *dataToPass = self.moviesArray[[self.tableView indexPathForCell:sender].row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end
