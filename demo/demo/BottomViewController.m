//
//  BottomViewController.m
//  demo
//
//  Created by Ton on 2020/12/24.
//

#import "BottomViewController.h"

@interface BottomViewController ()

@end

@implementation BottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 250);
}

@end
