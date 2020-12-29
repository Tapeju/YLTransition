//
//  CustomViewController.m
//  demo
//
//  Created by Ton on 2020/12/29.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 40, 300);
}


@end
