//
//  DetailsViewController.m
//  Flixter
//
//  Created by Max Bagatini Alves on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *movieImage;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *movieOverviewLabel;
@property (strong, nonatomic) IBOutlet UIImageView *transparentMovieImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTitleLabel.text = self.detailDict[@"title"];
    self.movieOverviewLabel.text = self.detailDict[@"overview"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"https://image.tmdb.org/t/p/w500", self.detailDict[@"poster_path"]];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.movieImage setImageWithURL:url];
    [self.transparentMovieImage setImageWithURL:url];
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSDictionary *dataToPass = self.detailDict;
    TrailerViewController *detailVC = [segue destinationViewController];
    detailVC.movieDict = dataToPass;
}


@end
