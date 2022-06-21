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
    self.movieTitleLabel.text = self.movie.title;
    self.movieOverviewLabel.text = self.movie.overview;
    [self.movieImage setImageWithURL:self.movie.posterUrl];
    [self.transparentMovieImage setImageWithURL:self.movie.posterUrl];
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    Movie *dataToPass = self.movie;
    TrailerViewController *trailerVC = [segue destinationViewController];
    trailerVC.movie = dataToPass;
}


@end
