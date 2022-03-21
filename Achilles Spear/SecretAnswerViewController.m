//
//  SecretAnswerViewController.m
//  Achilles Spear
//
//  Created by KP on 2/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SecretAnswerViewController.h"
#import "MBProgressHUD.h"
#import "HelperMethods.h"
#import "Util.h"

@interface SecretAnswerViewController ()

@end

@implementation SecretAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUserSecretQuestion];
    
    [[_okButton layer] setBorderWidth:1.0f];
    [[_okButton layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    
    [[_questionView layer] setBorderWidth:1.0f];
    [[_questionView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    
    [[_answerView layer] setBorderWidth:1.0f];
    [[_answerView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
}
- (void) getUserSecretQuestion {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    [HelperMethods getUserSecretQuestions:access_token completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    [HelperMethods showMessage:[response objectForKey:@"errors"]];
                } else {
                    secret_question_id = response[@"data"][@"id"];
                    [_secretQuestionTextField setText:[NSString stringWithFormat:@"Secret Question : %@", response[@"data"][@"question"]]];
                }
            }
        });
    }];
}
- (void) authorizeSecretAnswer:(NSString*) security_answer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    [HelperMethods authorizeUserSecretQuestions:access_token security_answer:security_answer completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    [HelperMethods showMessage:response[@"message"]];
                } else {
                    [HelperMethods setUserPreference:@"1" forKey:LOGGEDIN];
                    [self performSegueWithIdentifier:@"secret_to_main" sender: self];
                }
            }
        });
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self tapView:nil];
    return YES;
}

- (void) tapView:(UITapGestureRecognizer*)gesture {
    if ( tapGesture ) {
        
        [self scrollContent:150];
        
        [_secretAnswerTextField resignFirstResponder];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onOkClick:(id)sender {
    [self authorizeSecretAnswer: _secretAnswerTextField.text];
}
@end
