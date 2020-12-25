//
//  PresentedViewController.m
//  demo
//
//  Created by Ton on 2020/12/24.
//

#import "PresentedViewController.h"

@interface PresentedViewController ()

@end

@implementation PresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}


- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

/// 重写该方法 可以自适应弹出视图的frame
- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width , UIScreen.mainScreen.bounds.size.height);
}

- (void)dealloc {
    NSLog(@"%@%@ %@", @"- [", [self class], @"dealloc]");
}

@end
