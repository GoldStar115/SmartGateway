//
//  WebviewVC.h
//  ChatNLearn
//
//  Created by Grace on 15/9/15.
//
//

#import "ViewController.h"

@interface WebviewVC : ViewController
{
    IBOutlet UIWebView *webview;
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *urlContent;

@end
