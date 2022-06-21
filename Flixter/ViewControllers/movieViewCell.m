//
//  movieViewCell.m
//  Flixter
//
//  Created by Max Bagatini Alves on 6/15/22.
//

#import "movieViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation movieViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.

    _movie = movie;

    self.movieTitleLabel.text = self.movie.title;
    self.movieSynopsisLabel.text = self.movie.overview;

    self.imageMovieView.image = nil;
    if (self.movie.posterUrl != nil) {
        [self.imageMovieView setImageWithURL:self.movie.posterUrl];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
