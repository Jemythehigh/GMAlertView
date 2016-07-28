//
//  GMAlertView.h
//  GMAlertView
//
//  Created by Gaurav on 24/07/16.
//  Copyright © 2016 Gaurav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMAlertView : UIView

+ (GMAlertView *)sharedManager;
@property (strong, nonatomic) GMAlertView *alertView;

- (void)showMessageAlert:(NSString *)title message:(NSString *)message;

@end
