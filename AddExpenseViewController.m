//
//  AddExpenseViewController.m
//  Shoestring
//
//  Created by Mark Wigglesworth on 5/09/13.
//  Copyright (c) 2013 mark. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "TodayViewController.h"



@interface AddExpenseViewController ()

@end

@implementation AddExpenseViewController

@synthesize accomBtn, foodBtn, travelBtn, entertainBtn, shoppingBtn, btns, categoryNames, currentCategory, rating;
@synthesize itemNameField,placeNameField,amountField,savingTipField, rate;

@synthesize autocompleteTableView, autocompleteNames,itemNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialiseAutocomplete];
	
    //initialise button arrays for the button objects and names
    btns = [[NSArray alloc] initWithObjects:accomBtn, foodBtn, travelBtn, entertainBtn, shoppingBtn,  nil];
    categoryNames = [[NSArray alloc] initWithObjects:@"Accomodation", @"Food", @"Travel", @"Entertainment", @"Shopping", nil];

    [self setUpEditableRateView];
    
    //set delegates for keyboard dismissal
    [itemNameField setDelegate:self];
    [placeNameField setDelegate:self];
    [amountField setDelegate:self];
    [savingTipField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender {
    [[self delegate] addExpenseViewControllerDidCancel: [self currentExpense]];
}

- (IBAction)save:(id)sender {
    
    [[self currentExpense]setCategory:[currentCategory text]];
    [[self currentExpense]setItemName:[itemNameField text]];
    [[self currentExpense]setPlaceName:[placeNameField text]];
    
    NSNumberFormatter *formatString = [[NSNumberFormatter alloc]init];
    [[self currentExpense]setAmount: [formatString numberFromString:[amountField text]]];
    
    [[self currentExpense]setSavingTip:[savingTipField text]];
    [[self currentExpense]setRating: rate];
    [[self currentExpense]setDate:[self getTodaysDate]];
    
    [[self delegate] addExpenseViewControllerDidSave];
}

#pragma mark - Button Actions

//Methods for the icon actions
- (IBAction)accomBtn:(UIButton*)sender {
    [self changeSelection:sender];
}
- (IBAction)foodBtn:(UIButton*)sender {    
    [self changeSelection:sender];
}
- (IBAction)travelBtn:(UIButton*)sender {
    [self changeSelection:sender];
}
- (IBAction)entertainBtn:(UIButton*)sender {
    [self changeSelection:sender];
}
- (IBAction)shoppingBtn:(UIButton*)sender {
    [self changeSelection:sender];
}

//Method: change selection of current button
-(void) changeSelection:(UIButton*) currentBtn {
    [currentCategory setText:@""];
    if(currentBtn.selected == NO) {
        [currentBtn setSelected:YES];
        [currentCategory setText:categoryNames[currentBtn.tag]];
        [self setButtonsUnselected:currentBtn]; //set all buttons unselected except current
    } else {
        [currentBtn setSelected:NO];
    }
}


//Method: set all button except current as unselected
-(void) setButtonsUnselected:(UIButton *)currentBtn {
    for (UIButton *btn in btns) {
        if(btn.tag != currentBtn.tag) {
            [btn setSelected:NO];
        }
    }
}

#pragma mark - date method
-(NSDate*) getTodaysDate {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    return[calendar dateFromComponents:components];
}

#pragma mark - Rating View
- (void)setUpEditableRateView {
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 0, 200, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    rateView.padding = 10;
    rateView.alignment = RateViewAlignmentCenter;
    rateView.editable = YES;
    [rateView setDelegate:self];
    [self.rating addSubview:rateView];
    
    // Set up a label view to display rate
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 200, 25)];
    [[self rateLabel]setTextAlignment:NSTextAlignmentCenter];
    [[self rateLabel] setTextColor:[UIColor colorWithRed:10.0f/255 green:25.0f/255 blue:47.0f/255 alpha:1]];
    self.rateLabel.text = @"Tap above to rate";
    [self.rating addSubview:self.rateLabel];
}

#pragma mark - DYRateViewDelegate

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)ratedValue {
    self.rateLabel.text = [NSString stringWithFormat:@"Rating: %d", ratedValue.intValue];
    [self setRate:ratedValue];
}

#pragma mark - Dismiss keyboard

- (IBAction)dismissKeyboard:(id)sender {
    [[self view] endEditing:YES];
    [autocompleteTableView setHidden:YES];
}

- (IBAction)itemNameField:(id)sender {
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [autocompleteTableView setHidden:YES];
    return YES;
}


#pragma mark AutoComplete and UITextFieldDelegate methods

-(void)initialiseAutocomplete {
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 120) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    [autocompleteTableView setHidden:YES];
    [self.view addSubview:autocompleteTableView];
    
    self.itemNames = [[NSMutableArray alloc] initWithObjects:@"lunch",@"train",@"bus", @"dorm", @"rooom",@"burger",@"breakfast", @"dinner",@"beers", @"drinks", nil];
    self.autocompleteNames = [[NSMutableArray alloc] init];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteNames removeAllObjects];
    for(NSString *curString in itemNames) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompleteNames addObject:curString];
        }
    }
    [autocompleteTableView reloadData];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompleteNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier] ;
    }
    
    cell.textLabel.text = [autocompleteNames objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    itemNameField.text = selectedCell.textLabel.text;
    autocompleteTableView.hidden = YES;
    
    
    
}

@end
