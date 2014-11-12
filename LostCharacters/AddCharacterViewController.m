//
//  AddCharacterViewController.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/11/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "AddCharacterViewController.h"
#import "AppDelegate.h"
#import "CoreData.h"

@interface AddCharacterViewController () <UITextFieldDelegate>
@property NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UITextField *actorTextField;
@property (weak, nonatomic) IBOutlet UITextField *passengerTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *originTextField;
@property (weak, nonatomic) IBOutlet UIImageView *actorImageView;

@end

@implementation AddCharacterViewController

//MARK: project life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;
}

//MARK: dismiss keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.actorTextField resignFirstResponder];
    [self.passengerTextField resignFirstResponder];
    [self.genderTextField resignFirstResponder];
    [self.ageTextField resignFirstResponder];
    [self.originTextField resignFirstResponder];
    return YES;
}

//MARK: dimiss modal segue
- (IBAction)backOnButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)confirmOnButtonPressed:(UIButton *)sender
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    [coreDataManager storeLostCharactersByActorString:self.actorTextField.text
                                    byPassengerString:self.passengerTextField.text
                                       byGenderString:self.genderTextField.text
                                          byAgeString:self.ageTextField.text
                                       byOriginString:self.originTextField.text];
    self.actorTextField.text = @"";
    self.passengerTextField.text = @"";
    self.genderTextField.text = @"";
    self.ageTextField.text = @"";
    self.originTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
