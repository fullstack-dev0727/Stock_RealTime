//
//  SignupViewController.h
//  Achilles Spear
//
//  Created by KP on 2/9/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "ThemeBaseViewController.h"

@interface SignupViewController : ThemeBaseViewController <UITextFieldDelegate> {
    UITapGestureRecognizer* tapGesture;
    NSMutableArray* secret_questions;
    NSString* secret_question_id;
}
@property (weak, nonatomic) IBOutlet UIView *splashView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretQuestionsTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretAnswerTextField;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *secretQuestionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *firstNameView;
@property (weak, nonatomic) IBOutlet UIView *lastNameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordView;
@property (weak, nonatomic) IBOutlet UIView *secretAnswerView;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)onSignupClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;
- (void) signupFunc;
- (BOOL) checkFields;
@end
