//
//  ViewController.m
//  GMAlertView
//
//  Created by Gaurav on 24/07/16.
//  Copyright © 2016 Gaurav. All rights reserved.
//

#import "ViewController.h"
#import "GMAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self supportedInterfaceOrientations];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCustomAlert:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[GMAlertView sharedManager] showMessageAlert:@"Geeky!!" message:@"I fear the day that technology will surpass our human interaction. The world will have a generation of idiots."];
    });
    
}

@end
