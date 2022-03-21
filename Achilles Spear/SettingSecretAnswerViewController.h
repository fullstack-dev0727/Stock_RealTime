//
//  SettingViewController.h
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//
#import "BaseViewController.h"

@interface SettingSecretAnswerViewController : BaseViewController <UIAlertViewDelegate> {
    NSMutableArray* secret_questions;
    NSString* secret_question_id;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *secretQuestionsTextField;
@property (weak, nonatomic) IBOutlet UIView *secretQuestionView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UITextField *secretAnswerTextField;
- (BOOL) checkFields;
- (IBAction)onUpdateClick:(id)sender;
@end
