//
//  Movie.h
//  Flixter
//
//  Created by Max Bagatini Alves on 6/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, strong) NSString  *overview;
@property (nonatomic, strong) NSString  *ID;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
