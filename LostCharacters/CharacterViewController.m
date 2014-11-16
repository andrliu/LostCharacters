//
//  CharacterViewController.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/14/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "CharacterViewController.h"
#import "RelationshipViewController.h"
#import "CoreData.h"
#import "AppDelegate.h"

@interface CharacterViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *relationButton;
@property (weak, nonatomic) IBOutlet UITextField *actorTextField;
@property (weak, nonatomic) IBOutlet UITextField *passengerTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *originTextField;
@property (weak, nonatomic) IBOutlet UITextField *relationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property NSManagedObjectContext *moc;

@end

@implementation CharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.actorTextField.text = self.lostCharacter.actor;
    self.passengerTextField.text = self.lostCharacter.passenger;
    self.genderTextField.text = self.lostCharacter.gender;
    self.ageTextField.text = self.lostCharacter.age;
    self.originTextField.text = self.lostCharacter.origin;
    if (self.lostCharacter.lover)
    {
        self.relationButton.titleLabel.text = [NSString stringWithFormat:@"%@", self.lostCharacter.lover.actor];
    }
    else
    {
        self.relationButton.titleLabel.text = @"Relationship";
    }
    UIImage *photoImage = [[UIImage alloc]initWithData:self.lostCharacter.photo];
    self.photoImageView.image = photoImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.actorTextField resignFirstResponder];
    [self.passengerTextField resignFirstResponder];
    [self.genderTextField resignFirstResponder];
    [self.ageTextField resignFirstResponder];
    [self.originTextField resignFirstResponder];
    return YES;
}

- (IBAction)backforwardOnButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickImageOnButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = info[UIImagePickerControllerEditedImage];
    self.photoImageView.image = pickerImage;
    NSData *profileImageData = UIImagePNGRepresentation(pickerImage);
    self.lostCharacter.photo = profileImageData;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    RelationshipViewController *rvc = segue.destinationViewController;
    rvc.lostCharacter = self.lostCharacter;
    
}

- (IBAction)confirmOnButtonPressed:(UIButton *)sender
{
 
    self.lostCharacter.actor = self.actorTextField.text;
    self.lostCharacter.passenger = self.passengerTextField.text;
    self.lostCharacter.age = self.ageTextField.text;
    self.lostCharacter.gender = self.genderTextField.text;
    self.lostCharacter.origin = self.originTextField.text;
    [self.moc save:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
