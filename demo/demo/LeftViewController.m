//
//  LeftViewController.m
//  demo
//
//  Created by Ton on 2020/12/24.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(250, UIScreen.mainScreen.bounds.size.height);
}

@end
