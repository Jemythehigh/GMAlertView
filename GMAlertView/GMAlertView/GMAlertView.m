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

#define kCONST_ALERT_WIDTH_RATIO_IPHONE 0.80
#define kCONST_ALERT_WIDTH_RATIO_IPAD   0.50

#define isIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define alertbuttonTextColor [UIColor colorWithRed:60.0/255.0 green:137.0/255.0 blue:48.0/255.0 alpha:1.0]

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Add notification observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        //self.isShowNormalAlert = NO;
    }
    return self;
}
#pragma mark - Notification

- (void)deviceOrientationDidChange: (NSNotification *)notification

{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![GMAlertView sharedManager].isAlertRemovedSuccessFully) {
            [self removeAlertViewFromTopWindowForOrientation];
            [self showMessageAlert:[GMAlertView sharedManager].strTitle message:[GMAlertView sharedManager].strMessage];
        }
    });
}

#pragma mark - GMAlert methos
/**
 **   Add GMAlertView to window
 **/

- (void)showMessageAlert:(NSString *)title message:(NSString *)message
{
    [GMAlertView sharedManager].isShowNormalAlert = YES;
    [GMAlertView sharedManager].strTitle   = title;
    [GMAlertView sharedManager].strMessage = message;
    
    [GMAlertView sharedManager].isAlertRemovedSuccessFully = NO;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.subviews.count > 1) {
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:1];
    }else
    {
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }else
        {
            window = appDelegate.window;
        }
    }
    
    objGMAlert.alertView = [[GMAlertView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width, window.frame.size.height)];
    [objGMAlert.alertView setBackgroundColor:[UIColor clearColor]];
    //[objGMAlert.alertView setBackgroundColor:[UIColor greenColor]];
    
    UIView *vwBlur = [[GMAlertView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width, window.frame.size.height)];
    [vwBlur setBackgroundColor:[UIColor clearColor]];
    
    UIView *vwBlur1 = [[GMAlertView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width, window.frame.size.height)];
    [vwBlur1 setBackgroundColor:[UIColor lightGrayColor]];
    [vwBlur1 setAlpha:0.4];
    [vwBlur addSubview:vwBlur1];
    [objGMAlert.alertView addSubview:vwBlur];
    
    
    // Manage Alert width here by setting up ratio
    
    CGFloat ratio;
    
    if (isIPad) {
        ratio = kCONST_ALERT_WIDTH_RATIO_IPAD;
    }else
    {
        ratio = kCONST_ALERT_WIDTH_RATIO_IPHONE;
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0,  0.0, window.frame.size.width*ratio, window.frame.size.height/2 - 100)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    contentView.center = window.center;
    
    // Add header label to content view
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, contentView.frame.size.width - (kCONST_MARGIN_X*2), 21.0f)];
    [lblHeader setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [lblHeader setText:title];
    
    // Add header label to content view
    NSString *strMessage = (message.length == 0) ? @"" : message;
    
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(8.0, lblHeader.frame.origin.y + lblHeader.frame.size.height + (kCONST_MARGIN_Y*2), contentView.frame.size.width - (kCONST_MARGIN_X*2), 21.0f)];
    [lblMessage setNumberOfLines:0];
    [lblMessage setFont:[UIFont systemFontOfSize:14.0f]];
    
    // Calculate the actual height of message label
    CGRect textRect = [strMessage boundingRectWithSize:CGSizeMake(lblHeader.frame.size.width, 126.0f)
                                               options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:lblMessage.font}
                                               context:nil];
    [lblMessage setText:strMessage];
    
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
    //[btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 setTitleColor:alertbuttonTextColor forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(removeAlertViewFromTopWindow) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn1];
    
    // Set Final height of content view
    CGRect contentFrame = contentView.frame;
    contentFrame.size.height = btn1.frame.origin.y + 40.0f + (kCONST_MARGIN_Y*3);
    contentView.frame = contentFrame;
    
    [window addSubview:objGMAlert.alertView];
    //[window addSubview:];
    
}

/**
 **   Remove GMAlertView from window
 **/
- (void)removeAlertViewFromTopWindow
{
    [objGMAlert.alertView removeFromSuperview];
    
    [GMAlertView sharedManager].isShowNormalAlert = NO;
    [GMAlertView sharedManager].isAlertRemovedSuccessFully = YES;
    
    if ([self.delegate respondsToSelector:@selector(alertRemovedSuccessFully)]) {
        [self.delegate alertRemovedSuccessFully];
    }
}

- (void)removeAlertViewFromTopWindowForOrientation
{
    [objGMAlert.alertView removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(alertRemovedSuccessFully)]) {
        [self.delegate alertRemovedSuccessFully];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // Drop shadow
    [self.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:6.0];
    [self.layer setShadowOffset:CGSizeMake(4.0, 10.0)];
}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end
