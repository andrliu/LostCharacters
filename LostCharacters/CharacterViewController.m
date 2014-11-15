//
//  CharacterViewController.m
//  LostCharacters
//
//  Created by Andrew Liu on 11/14/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "CharacterViewController.h"
#import "CoreData.h"

@interface CharacterViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
    
    self.actorTextField.text = [self.lostCharacter valueForKey:@"actor"];
    self.passengerTextField.text = [self.lostCharacter valueForKey:@"passenger"];
    self.genderTextField.text = [self.lostCharacter valueForKey:@"gender"];
    self.ageTextField.text = [self.lostCharacter valueForKey:@"age"];
    self.originTextField.text = [self.lostCharacter valueForKey:@"origin"];
    UIImage *photoImage = [[UIImage alloc]initWithData:[self.lostCharacter valueForKey:@"photo"]];
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
    [self.lostCharacter setValue:profileImageData forKey:@"photo"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmOnButtonPressed:(UIButton *)sender
{
 
    [self.lostCharacter setValue:self.actorTextField.text forKey:@"actor"];
    [self.lostCharacter setValue:self.passengerTextField.text forKey:@"passenger"];
    [self.lostCharacter setValue:self.ageTextField.text forKey:@"age"];
    [self.lostCharacter setValue:self.genderTextField.text forKey:@"gender"];
    [self.lostCharacter setValue:self.originTextField.text forKey:@"origin"];
    [self.moc save:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
