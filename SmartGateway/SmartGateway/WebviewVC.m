//
//  WebviewVC.m
//  ChatNLearn
//
//  Created by Grace on 15/9/15.
//
//

#import "WebviewVC.h"

@interface WebviewVC ()

@end

@implementation WebviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = localize(self.baseTitle.uppercaseString);
    
    if(self.urlString && self.urlString.length > 0)
    {
        NSString *searchStr = @"http";
        NSRange range = [self.urlString rangeOfString:searchStr];
        
        if (range.location == NSNotFound)
        {
            self.urlString = [@"http://" stringByAppendingString:self.urlString];
        }
        
        NSURL *url = [NSURL URLWithString:self.urlString];
//        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *reqObj = [NSMutableURLRequest requestWithURL:url];
        
        [reqObj addValue:[dm getSavedToken] forHTTPHeaderField:@"Authorization"];
        
//        [webview loadRequest:requestObj];
        [webview loadRequest:reqObj];
    }
    else if(self.urlContent && self.urlContent.length > 0)
    {
        [webview loadHTMLString:self.urlContent baseURL:nil];
    }
//    webview.scalesPageToFit = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([webview isLoading]){
        [webview stopLoading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web View Delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
