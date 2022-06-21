//
//  TrailerViewController.m
//  Flixter
//
//  Created by Max Bagatini Alves on 6/17/22.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>


@interface TrailerViewController ()
@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic, strong) NSArray *videosArray;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlString = @"https://api.themoviedb.org/3/movie/";
    NSString *videoAPI = @"/videos?api_key=9017031209ee56001d137e43569ed1cf";
    urlString = [NSString stringWithFormat:@"%@%@%@", urlString, self.movie.ID, videoAPI];
    NSLog(@"%@", urlString);
    // Convert the url String to a NSURL object.
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               self.videosArray = dataDict[@"results"];
               
               int i = 0;
               while (![self.videosArray[i][@"type"] isEqualToString:@"Trailer"]) {
                   i++;
               }
               
               NSString *youtubeUrlString = [NSString stringWithFormat:@"%@%@", @"https://www.youtube.com/embed/", self.videosArray[i][@"key"]];
               NSURL *youtubeUrl = [NSURL URLWithString:youtubeUrlString];
               
               // THIS IS FOR LOADING THE TRAILER! //
               // Place the URL in a URL Request.
               NSURLRequest *requestTrailer = [NSURLRequest requestWithURL:youtubeUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
               
               // Load Request into WebView.
               [self.webView loadRequest:requestTrailer];
           }
       }];
    [task resume];
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
