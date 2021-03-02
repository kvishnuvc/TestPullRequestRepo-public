//
//  ViewController.h
//  ContactTest
//
//  Created by Rajesh Sahu on 3/2/17.
//  Copyright © 2017 Rajesh Sahu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


@interface ViewController : UIViewController<CNContactPickerDelegate, CNContactViewControllerDelegate>


@end

