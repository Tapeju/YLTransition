//
//  RightViewController.m
//  demo
//
//  Created by Ton on 2020/12/24.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self netWorkRequest];
}

- (void)netWorkRequest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.preferredContentSize = CGSizeMake(350, UIScreen.mainScreen.bounds.size.height);
    });
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(250, UIScreen.mainScreen.bounds.size.height);
}


@end
