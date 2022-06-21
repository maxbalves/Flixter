//
//  movieViewCell.h
//  Flixter
//
//  Created by Max Bagatini Alves on 6/15/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface movieViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageMovieView;
@property (strong, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (nonatomic, strong) Movie *movie;
@end

NS_ASSUME_NONNULL_END
