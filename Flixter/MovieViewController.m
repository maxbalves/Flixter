//
//  MovieViewController.m
//  Flixter
//
//  Created by Max Bagatini Alves on 6/15/22.
//

#import "MovieViewController.h"

@interface MovieViewController () <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *moviesArray;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moviesArray = @[@"New York, NY", @"Los Angeles, CA", @"Chicago, IL", @"Houston, TX",
                 @"Philadelphia, PA", @"Phoenix, AZ", @"San Diego, CA", @"San Antonio, TX",
                 @"Dallas, TX", @"Detroit, MI", @"San Jose, CA", @"Indianapolis, IN",
                 @"Jacksonville, FL", @"San Francisco, CA", @"Columbus, OH", @"Austin, TX",
                 @"Memphis, TN", @"Baltimore, MD", @"Charlotte, ND", @"Fort Worth, TX"];
    self.tableView.dataSource = self;
    
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=9017031209ee56001d137e43569ed1cf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
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
               self.tableView.dataSource = self;
           }
       }];
    [task resume];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.moviesArray[indexPath.row];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moviesArray.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
