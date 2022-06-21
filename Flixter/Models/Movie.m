//
//  Movie.m
//  Flixter
//
//  Created by Max Bagatini Alves on 6/21/22.
//

#import "Movie.h"

@implementation Movie

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    self.posterUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, dictionary[@"poster_path"]]];
    
    self.overview = dictionary[@"overview"];
    
    self.ID = dictionary[@"id"];
    
    return self;
}

// Movie.m
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
   // Implement this function
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];

        [movies addObject:movie];
    }
    
    return (NSArray *)movies;
}

@end
