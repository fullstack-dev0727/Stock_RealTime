//
//  SecretAnswerViewController.h
//  Achilles Spear
//
//  Created by KP on 2/9/16.
//  Copyright © 2016 ; Balkans. All rights reserved.
//

#import "ThemeBaseViewController.h"

@interface SecretAnswerViewController : ThemeBaseViewController <UITextFieldDelegate> {
    UITapGestureRecognizer* tapGesture;
    NSString* secret_question_id;
}
@property (weak, nonatomic) IBOutlet UITextField *secretQuestionTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretAnswerTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UIView *answerView;

- (IBAction)onOkClick:(id)sender;
- (void) authorizeSecretAnswer:(NSString*) security_answer;
- (void) getUserSecretQuestion;

@end
