//
//  GMAlertView.h
//  GMAlertView
//
//  Created by Gaurav on 24/07/16.
//  Copyright © 2016 Gaurav. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GMAlertDelegate <NSObject>

@optional
// Do something after removal of GMAlert
- (void)alertRemovedSuccessFully;

@end

@interface GMAlertView : UIView

+ (GMAlertView *)sharedManager;

@property (weak, nonatomic) id<GMAlertDelegate>delegate;

@property (strong, nonatomic) GMAlertView *alertView;

@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strMessage;

@property (nonatomic) BOOL isShowNormalAlert;

@property (nonatomic) BOOL isAlertRemovedSuccessFully;
//@property (nonatomic) BOOL isShowAlertWithCustomButtons;

//@property (nonatomic, strong)  NSArray *arrButton;

- (void)showMessageAlert:(NSString *)title message:(NSString *)message;


@end
