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
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(250, UIScreen.mainScreen.bounds.size.height);
}


@end
