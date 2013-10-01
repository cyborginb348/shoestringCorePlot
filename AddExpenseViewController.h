//
//  AddExpenseViewController.h
//  Shoestring
//
//  Created by Mark Wigglesworth on 5/09/13.
//  Copyright (c) 2013 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"
#import "DYRateView.h"

@protocol AddExpenseViewControllerDelegate;

@interface AddExpenseViewController : UIViewController
<UITextFieldDelegate, DYRateViewDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (void)setUpEditableRateView;
- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)itemNameField:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *accomBtn;
- (IBAction)accomBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *foodBtn;
- (IBAction)foodBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *travelBtn;
- (IBAction)travelBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *entertainBtn;
- (IBAction)entertainBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shoppingBtn;
- (IBAction)shoppingBtn:(id)sender;

@property (strong, nonatomic) NSArray *btns;
@property (strong, nonatomic) NSArray *categoryNames;

@property (weak, nonatomic) IBOutlet UIView *rating;
@property(nonatomic, retain) UILabel *rateLabel;

@property (nonatomic, strong) Expense *currentExpense;
@property (weak, nonatomic) IBOutlet UILabel *currentCategory;
@property (weak, nonatomic) IBOutlet UITextField *itemNameField;
@property (weak, nonatomic) IBOutlet UITextField *placeNameField;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *savingTipField;
@property (strong, nonatomic) NSNumber *rate;


@property (nonatomic, weak) id <AddExpenseViewControllerDelegate> delegate;

@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic, retain) NSMutableArray *itemNames;
@property (nonatomic, retain) NSMutableArray *autocompleteNames;

@end


//protocol for delegate
@protocol AddExpenseViewControllerDelegate

-(void) addExpenseViewControllerDidSave;
-(void) addExpenseViewControllerDidCancel: (Expense*) expenseToDelete;

@end
