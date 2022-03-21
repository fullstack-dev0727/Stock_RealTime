//
//  LoginViewController.m
//  Achilles Spear
//
//  Created by KP on 2/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "HelperMethods.h"
#import "Util.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[_loginButton layer] setBorderWidth:1.0f];
    [[_loginButton layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    
    [[_signupButton layer] setBorderWidth:1.0f];
    [[_signupButton layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    
    [[_emailView layer] setBorderWidth:1.0f];
    [[_emailView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    
    [[_passwordView layer] setBorderWidth:1.0f];
    [[_passwordView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    
    [HelperMethods setColorThemeData];
    
    [_guideLabel setTextColor:[HelperMethods getStuffColor:TEXT]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)onSignupClick:(id)sender {
    [self performSegueWithIdentifier:@"login_to_signup" sender: self];
}

- (IBAction)onLoginClick:(id)sender {
    if (![self checkEmailAndPassword])
        return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HelperMethods loginFunc:_emailTextField.text password:_passwordTextField.text completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    [HelperMethods showMessage:[response objectForKey:@"errors"]];
                } else {
                    [HelperMethods setUserPreference:response[@"access_token"] forKey:ACCESSTOKEN];
                    [HelperMethods setUserPreference:response[@"user_id"] forKey:USERID];
                    [self performSegueWithIdentifier:@"login_to_secret" sender: self];
                }
            }
        });
    }];
}
- (BOOL) checkEmailAndPassword {
    if ([_emailTextField.text length] == 0) {
        [HelperMethods showMessage:@"Invalid email or username taken."];
        return NO;
    }
    if([_passwordTextField.text length] == 0) {
        [HelperMethods showMessage:@"Please enter password."];
        return NO;
    }
    return true;
}
#pragma mark -
#pragma mark UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if ( !tapGesture ) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self.view addGestureRecognizer:tapGesture];
        
        [self scrollContent:-150];
    }
}
- (void)textFieldDidEndEditing:(UITextField *) textField {
    CGRect rtView = self.view.frame;
    if (rtView.origin.y < 0) {
        [self tapView:nil];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *) textField {
    if ( textField == _emailTextField )
        [_passwordTextField becomeFirstResponder];
    else
        [self tapView:nil];
    
    return YES;
}

- (void) tapView:(UITapGestureRecognizer*)gesture {
    if ( tapGesture ) {
        
        [self scrollContent:150];
        
        [_emailTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];
        
        [self.view removeGestureRecognizer:tapGesture];
        tapGesture = nil;
    }
}
- (void) scrollContent:(int)offsetY {
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rtView = self.view.frame;
                         rtView.origin.y += offsetY;
                         
                         self.view.frame = rtView;
                     }];
}

@end
