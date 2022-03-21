//
//  SettingViewController.m
//  Achilles Spear
//
//  Created by KP on 2/11/16.
//  Copyright © 2016 Kaz Balkans. All rights reserved.
//

#import "SettingSecretAnswerViewController.h"
#import "KxMenu.h"
#import "Util.h"
#import "MainViewController.h"
#import "HelperMethods.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "MBProgressHUD.h"
#import "HelperMethods.h"

@interface SettingSecretAnswerViewController ()

@end

@implementation SettingSecretAnswerViewController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width - (MENU_WIDTH + SUBMENU_WIDTH), self.view.frame.size.height);
    [HelperMethods postNotificationWithName:@"setTitle" withCategoryId:@"Setting / SecretAnswer"];
    
    [[_saveButton layer] setBorderWidth:1.0f];
    [[_saveButton layer] setBorderColor:[HelperMethods getStuffColor:LINE].CGColor];
    
    [_questionLabel setTextColor:[HelperMethods getStuffColor:TEXT]];
    [_answerLabel setTextColor:[HelperMethods getStuffColor:TEXT]];
    
    [self getUserSecretQuestion];
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    if (textField.tag == 4) {
        [self showMenu:textField];
        return NO;
    }
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) getUserSecretQuestion {
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    [HelperMethods getUserSecretQuestions:access_token completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.contentView animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    NSString* message = [response objectForKey:@"errors"];
                    if ([message isEqualToString:@"Your session is expired. Please sign in again."]) {
                        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    } else {
                        [HelperMethods showMessage:message];
                    }
                } else {
                    secret_question_id = response[@"data"][@"id"];
                    [_secretQuestionsTextField setText:[NSString stringWithFormat:@"%@", response[@"data"][@"question"]]];
                }
            }
        });
    }];
}
- (void) updateSecretAnswer:(NSString*) security_answer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* access_token = [HelperMethods getUserPreference:ACCESSTOKEN];
    [HelperMethods updateUserSecretQuestions:access_token security_question_id:secret_question_id security_answer:security_answer completion:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (response == nil) {
                [HelperMethods showMessage:@"Please check internet connection, and try again!"];
            } else {
                int status = [response[@"status"] intValue];
                if (status != 200) {
                    NSString* message = [response objectForKey:@"errors"];
                    if ([message isEqualToString:@"Your session is expired. Please sign in again."]) {
                        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    } else {
                        [HelperMethods showMessage:message];
                    }
                } else {
                    [HelperMethods showMessage:@"Secret Answer has been updated!"];
                    [_secretAnswerTextField setText:@""];
                }
            }
        });
    }];
}
- (BOOL) checkFields {
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

- (IBAction)onUpdateClick:(id)sender {
    if (![self checkFields])
        return;
    [self updateSecretAnswer:_secretAnswerTextField.text];
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
    
    [KxMenu showMenuInView:self.contentView
                  fromRect:self.contentView.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem* item = (KxMenuItem*) sender;
    [_secretQuestionsTextField setText:item.title];
    secret_question_id = item.secretId;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self logout];
    }
    
}
@end
