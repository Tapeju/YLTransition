//
//  TopViewController.m
//  demo
//
//  Created by Ton on 2020/12/24.
//

#import "TopViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self netWorkRequest];
}

- (void)netWorkRequest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 350);
    });
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 250);
}

@end
