//
//  ViewController.m
//  ContactTest
//
//  Created by Rajesh Sahu on 3/2/17.
//  Copyright © 2017 Rajesh Sahu. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
{
    CNContact *_contact;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = true;
    
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UINavigationBar appearance].translucent = true;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSelectedContactList:(id)sender {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
//    picker.DisplayedPropertyKeys = new NSString[] { CNContactKey.PhoneNumbers };
//    picker.PredicateForEnablingContact = NSPredicate.FromFormat("phoneNumbers.@count > 0");
//    picker.PredicateForSelectionOfContact = NSPredicate.FromFormat("phoneNumbers.@count == 1");
//    // Respond to selection
//    picker.Delegate = new ContactPickerDelegate(ViewModel, this);
//    UINavigationBar.Appearance.Translucent = false;
//    // Display picker
//    
//    PresentViewController(picker, true, null);
    
    picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    picker.predicateForSelectionOfContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count == 1"];
    
    [UINavigationBar appearance].translucent = false;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


/*!
 * @abstract Invoked when the picker is closed.
 * @discussion The picker will be dismissed automatically after a contact or property is picked.
 */
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    NSLog(@"id : %@", picker);
    picker.delegate = nil;
}

/*!
 * @abstract Singular delegate methods.
 * @discussion These delegate methods will be invoked when the user selects a single contact or property.

 * bstract Singular delegate methods.
 * iscussion These delegate methods will be invoked when the user selects a single contact or property.

 * stract Singular delegate methods.
 * scussion These delegate methods will be invoked when the user selects a single contact or property.
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    _contact = contact;
    NSLog(@"contact id : %@", contact.identifier);
    picker.delegate = nil;
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
}

- (IBAction)didSelectedAddContact:(id)sender {
    CNMutableContact *contact =  [CNMutableContact new];

    CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:NULL];
    
    NSLog(@"contact id : %@", contact.identifier);
    
    contactController.allowsEditing = true;
    contactController.allowsActions = true;
    
    CNContactStore *store = [CNContactStore new];
    contactController.contactStore = store;
    
    contactController.delegate = self;
    
    
    [self.navigationController pushViewController:contactController animated:YES];
    
}

- (IBAction)didSelectedEditContact:(id)sender
{
    [self performSegueWithIdentifier:@"ContactDetailViewController" sender:NULL];
}

- (CNContact*) getContactFromStoreForIdentifier:(NSString*) identifier
{
    CNContact *updatedContact = nil;
    
    id descriptor = [CNContactViewController descriptorForRequiredKeys];
    
    CNContactStore *store = [CNContactStore new];
    
    NSError *error;
    
    updatedContact = [store unifiedContactWithIdentifier:identifier
                                             keysToFetch:@[descriptor]
                                                   error:&error];
    // Found?
    if (updatedContact == nil)
    {
        if (error != nil)
        {
        
        }
    }
    
    return updatedContact;
}

- (BOOL) checkContactsAccess
{
    bool result = false;
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (authStatus)
    {
        case CNAuthorizationStatusAuthorized:
            result = true;
            break;
        case CNAuthorizationStatusNotDetermined:
        {
          CNContactStore *store = [CNContactStore new];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
            }];

        }
            break;
        case CNAuthorizationStatusDenied:
        
            break;
        case CNAuthorizationStatusRestricted:
            
            break;
            
    }
    
    return result;
}


//- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property{
//    return YES;
//}

/*!
 * @abstract Called when the view has completed.
 * @discussion If creating a new contact, the new contact added to the contacts list will be passed.
 * If adding to an existing contact, the existing contact will be passed.
 * @note It is up to the delegate to dismiss the view controller.
 */
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    _contact = contact;
    
    
    if (viewController.isBeingPresented)
        [viewController dismissViewControllerAnimated:YES completion:NULL];
    else
        [viewController.navigationController popViewControllerAnimated:YES];
}
@end
