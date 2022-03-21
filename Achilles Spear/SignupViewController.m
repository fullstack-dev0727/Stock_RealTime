//
//  SignupViewController.m
//  Achilles Spear
//
//  Created by KP on 2/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SignupViewController.h"
#import "KxMenu.h"
#import "HelperMethods.h"
#import "MBProgressHUD.h"
#import "Util.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50)];
    
    [[_signupButton layer] setBorderWidth:1.0f];
    [[_signupButton layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_cancelButton layer] setBorderWidth:1.0f];
    [[_cancelButton layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_usernameView layer] setBorderWidth:1.0f];
    [[_usernameView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_emailView layer] setBorderWidth:1.0f];
    [[_emailView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_firstNameView layer] setBorderWidth:1.0f];
    [[_firstNameView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_lastNameView layer] setBorderWidth:1.0f];
    [[_lastNameView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_passwordView layer] setBorderWidth:1.0f];
    [[_passwordView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_confirmPasswordView layer] setBorderWidth:1.0f];
    [[_confirmPasswordView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_secretQuestionView layer] setBorderWidth:1.0f];
    [[_secretQuestionView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];
    [[_secretAnswerView layer] setBorderWidth:1.0f];
    [[_secretAnswerView layer] setBorderColor:UIColorFromRGB(0x0f2149).CGColor];

}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    secret_questions = [HelperMethods getUserPreference:SECRETQUESTIONS];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HelperMethods getSecretQuestions:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        int status = [response[@"status"] intValue];
        if (status == 200) {
            NSLog(@"%@", response[@"data"]);
            [HelperMethods setUserPreference:response[@"data"] forKey:SECRETQUESTIONS];
        }
    }];
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSignupClick:(id)sender {
    [self signupFunc];
}
- (BOOL) checkFields {
    if ([_usernameTextField.text length] == 0) {
        [HelperMethods showMessage:@"Please enter username."];
        return NO;
    }
    if ([_firstNameTextField.text length] == 0) {
        [HelperMethods showMessage:@"Please enter first name."];
        return NO;
    }
    if ([_lastNameTextField.text length] == 0) {
        [HelperMethods showMessage:@"Please enter last name."];
        return NO;
    }
    if (![HelperMethods isValidEmail :_emailTextField.text]) {
        [HelperMethods showMessage:@"Invalid email taken."];
        return NO;
    }
    if ([_passwordTextField.text length] == 0) {
        [HelperMethods showMessage:@"Please enter password."];
        return NO;
    }
    if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        [HelperMethods showMessage:@"These passwords don't match."];
        return NO;
    }
    if ([_secretQuestionsTextField.text length] == 0) {
        [HelperMethods showMessage:@"Please choose the secret question."];
        return NO;
    }
    if ([_secretAnswerTextField.text length] == 0) {
        [HelperMethods showMessage:@"Please enter secret answer."];
        return NO;
    }
    return YES;
}
- (void) signupFunc {
    if (![self checkFields])
        return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HelperMethods signupFunc:_emailTextField.text username:_usernameTextField.text password:_passwordTextField.text password_confirmation:_confirmPasswordTextField.text first_name:_firstNameTextField.text last_name:_lastNameTextField.text security_question_id:secret_question_id security_answer:_secretAnswerTextField.text completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    if ([response[@"errors"] allKeys] > 0) {
                        NSString* key = [[response[@"errors"] allKeys] objectAtIndex:0];
                        NSArray* values = response[@"errors"][key];
                        [HelperMethods showMessage:[NSString stringWithFormat:@"%@ %@", key, values[0]]];
                    } else {
                        [HelperMethods showMessage:response[@"errors"]];
                    }
                    
                } else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Achilles Spear"
                                                                                             message:@"Please wait until the signup request is accepted."
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    //We add buttons to the alert controller by creating UIAlertActions:
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action){
                                                                         [self dismissViewControllerAnimated:YES completion:nil];
                                                                     }]; //You can use a block here to handle a press on this button
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        });
    }];
    
    
}
- (IBAction)onCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if ( !tapGesture ) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self.view addGestureRecognizer:tapGesture];
        
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.3f)];
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 120;
        [_scrollView setContentOffset:pt animated:NO];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tapView:nil];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 7) {
        [self tapView:nil];
        [self showMenu:textField];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *) textField {
    if (_scrollView.contentSize.height > self.view.frame.size.height + 50) {
        [self tapView:nil];
    }
}
- (void) tapView:(UITapGestureRecognizer*)gesture {
    if ( tapGesture ) {
        
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50)];
        
        [_emailTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];
        [_confirmPasswordTextField resignFirstResponder];
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
- (void)showMenu:(UITextField *)sender
{
    secret_questions = [HelperMethods getUserPreference:SECRETQUESTIONS];
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (int i = 0;i < [secret_questions count]; i++) {
        NSDictionary* questionItem = [secret_questions objectAtIndex:i];
        KxMenuItem* item = [KxMenuItem menuItem:questionItem[@"question"]
                                       secretId:questionItem[@"id"]
                                          image:nil
                                         target:self
                                         action:@selector(pushMenuItem:)];
        item.foreColor = [HelperMethods getStuffColor:TEXT];
        [menuItems addObject:item];
    }
   
    [KxMenu showMenuInView:self.view
                  fromRect:self.view.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem* item = (KxMenuItem*) sender;
    [_secretQuestionsTextField setText:item.title];
    secret_question_id = item.secretId;
    
}
@end
