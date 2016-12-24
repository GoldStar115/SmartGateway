//
//  PopupVC.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "PopupVC.h"

@interface PopupVC ()

@end

@implementation PopupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.message)
        textLabel.text = self.message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)yesClicked:(id)sender
{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(popup:didClickYes:)])
//        [self.delegate popup:self didClickYes:sender];
    if(_yesBlock)
        _yesBlock(sender);
    [self remove];
}

- (IBAction)cancelClicked:(id)sender
{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(popup:didClickCancel:)])
//        [self.delegate popup:self didClickCancel:sender];    
    if(_cancelBlock)
        _cancelBlock(sender);
    [self remove];
}

- (void)remove
{
    [self dismissViewControllerAnimated:NO completion:^{}];
}

//-(BOOL) callMGSwipeConvenienceCallback: (UIViewController *) sender
//{
//    if (_callback) {
//        return _callback(sender);
//    }
//    return NO;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
