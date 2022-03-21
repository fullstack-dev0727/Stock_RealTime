//
//  LoginViewController.h
//  Achilles Spear
//
//  Created by KP on 2/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "ThemeBaseViewController.h"
#import "AppConstants.h"
#import "HelperMethods.h"

@interface LoginViewController : ThemeBaseViewController <UITextFieldDelegate> {
    UITapGestureRecognizer* tapGesture;
}
@property (weak, nonatomic) IBOutlet UIView *splashView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UILabel *guideLabel;


- (IBAction)onSignupClick:(id)sender;
- (IBAction)onLoginClick:(id)sender;

@end
