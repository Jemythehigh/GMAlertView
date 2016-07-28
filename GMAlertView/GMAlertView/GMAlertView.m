//
//  GMAlertView.m
//  GMAlertView
//
//  Created by Gaurav on 24/07/16.
//  Copyright © 2016 Gaurav. All rights reserved.
//

#import "GMAlertView.h"
#import "AppDelegate.h"

#define kCONST_MARGIN_X 8.0f
#define kCONST_MARGIN_Y 8.0f

#define kCONST_ALERT_WIDTH_RATIO_IPHONE 0.50
#define kCONST_ALERT_WIDTH_RATIO_IPAD   0.50

static GMAlertView *objGMAlert = nil;

@implementation GMAlertView

UIWindow *window;

// Shared Manager

+ (GMAlertView *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Initialize
        objGMAlert = [GMAlertView new];
        
    });
    return objGMAlert;
}

/**
 **   Add GMAlertView to window
 **/

- (void)showMessageAlert:(NSString *)title message:(NSString *)message
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    window =  appDelegate.window;
   // window = [UIApplication sharedApplication].keyWindow;
    
    objGMAlert.alertView = [[GMAlertView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width, window.frame.size.height)];
    [objGMAlert.alertView setBackgroundColor:[UIColor clearColor]];
    
    UIView *vwBlur = [[GMAlertView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width, window.frame.size.height)];
    [vwBlur setBackgroundColor:[UIColor clearColor]];
    
    UIView *vwBlur1 = [[GMAlertView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width, window.frame.size.height)];
    [vwBlur1 setBackgroundColor:[UIColor grayColor]];
    [vwBlur1 setAlpha:0.7];
    [vwBlur addSubview:vwBlur1];
     [objGMAlert.alertView addSubview:vwBlur];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width*kCONST_ALERT_WIDTH_RATIO_IPHONE, window.frame.size.height/2 - 100)];
    [contentView setBackgroundColor:[UIColor greenColor]];
    contentView.center = window.center;
    
    // Add header label to content view
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, contentView.frame.size.width - (kCONST_MARGIN_X*2), 21.0f)];
    [lblHeader setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [lblHeader setText:title];
    
    // Add header label to content view
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(8.0, lblHeader.frame.origin.y + lblHeader.frame.size.height + (kCONST_MARGIN_Y*2), contentView.frame.size.width - (kCONST_MARGIN_X*2), 21.0f)];
    [lblMessage setNumberOfLines:0];
    [lblMessage setFont:[UIFont systemFontOfSize:14.0f]];
    
    // Calculate the actual height of message label
    CGRect textRect = [message boundingRectWithSize:CGSizeMake(lblHeader.frame.size.width, 126.0f)
                                            options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:lblMessage.font}
                                            context:nil];
    [lblMessage setText:message];
    
    // Set Original height of message label
    CGRect newFrame = lblMessage.frame;
    newFrame.size.height = textRect.size.height;
    lblMessage.frame = newFrame;
    
    [contentView addSubview:lblHeader];
    [contentView addSubview:lblMessage];
    [objGMAlert.alertView addSubview:contentView];
    
    // Add Button 1 to content view
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake((contentView.frame.size.width/3 *2), lblMessage.frame.origin.y + lblMessage.frame.size.height + (kCONST_MARGIN_Y*3), contentView.frame.size.width/3, 40.0f)];
    [btn1 setTitle:@"OK" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(removeAlertViewFromTopWindow) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn1];
    
    // Set Final height of content view
    CGRect contentFrame = contentView.frame;
    contentFrame.size.height = btn1.frame.origin.y + 40.0f + (kCONST_MARGIN_Y*3);
    contentView.frame = contentFrame;
    
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [[[window subviews] objectAtIndex:0] addSubview:objGMAlert.alertView];
    //[window addSubview:];
    
}

/**
 **   Remove GMAlertView from window
 **/
- (void)removeAlertViewFromTopWindow
{
    [objGMAlert.alertView removeFromSuperview];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

//

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
