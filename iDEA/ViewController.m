//
//  ViewController.m
//  iDEA
//
//  Created by Trey Hambrick on 4/27/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "CustomSegue.h"


@interface AddressAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *mTitle;
    NSString *mSubTitle;
}
@end

@implementation AddressAnnotation

    @synthesize coordinate;

    - (NSString *)subtitle{
        NSString *cords= [NSString stringWithFormat:@"%f, %f",coordinate.latitude, coordinate.longitude];
        return cords;
    }
    
    - (NSString *)title{
        return @"Location";
    }
    
    -(id)initWithCoordinate:(CLLocationCoordinate2D) c{
        coordinate=c;
        //NSLog(@"%f,%f",c.latitude,c.longitude);
        return self;
    }
@end


@interface ViewController ()
{
    NSManagedObjectContext *context;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@end


@implementation ViewController

@synthesize library;

Incident *currentIncident;
Pictures *currentPicture;
LocalVarables *currentLocalVariables;

NSMutableArray *localVariablesArray;
NSMutableArray *incidentArray;
NSMutableArray *picturesArray;
NSMutableArray *picturesURLArray;


ViewController *anotherVC;
NSEntityDescription *entityDesc;
NSFetchRequest *request;
NSPredicate *predicate;
NSSortDescriptor* sortDescriptor;
NSArray* sortDescriptors;

int incidentNumberInt;      //the id for the new screen


NSNumber *nextPictureId;
NSNumber *returnToTab;

NSString *enteredPasscode;
NSString *newInstallation;
NSString *deleteFlag;

NSMutableArray *photos;

NSString *assetAbsoluteString;
NSString *photoFolder;
UIImage *localImage;


#pragma mark - for controls
- (IBAction)changedValue:(id)sender {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}
-(void)cancelNumberPad{
    [_amount resignFirstResponder];
    [_numberSubjects resignFirstResponder];
}

-(void)doneWithNumberPad{
    [_amount resignFirstResponder];
    [_numberSubjects resignFirstResponder]; 
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag!=0)
    {
        textField.text = @"X";
    } else {
        [scrollView setContentOffset:CGPointZero animated:YES];
        [self save];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textField
{
    if (textField.tag!=0)
    {
        textField.text = @"X";
    } else {
        [scrollView setContentOffset:CGPointZero animated:YES];
        [self save];
    }
}

- (void)textViewDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [scrollView setContentOffset:scrollPoint animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _eventDatePicker.hidden=TRUE;
    
    if (textField.tag!=0) {
        enteredPasscode = [NSString stringWithFormat:@"%@%@",enteredPasscode, string];
        
        if (textField.tag==1) {
            [_pass2 becomeFirstResponder];
        }
        else if (textField.tag==2) {
            [_pass3 becomeFirstResponder];
        }
        else if (textField.tag==3) {
            [_pass4 becomeFirstResponder];
        }
        else if (textField.tag==4) {
            [self verifyPasscode];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _eventDatePicker.hidden=TRUE;
    _eventPicker.hidden=TRUE;
    if (textField.tag==20){
        [self.view endEditing:YES];
        _eventDatePicker.hidden=TRUE;
        _eventPicker.hidden=FALSE;
        return NO;
    } else if (textField.tag==10){
        [self.view endEditing:YES];
        _eventPicker.hidden=TRUE;
        _eventDatePicker.hidden=FALSE;
        return NO;
    } else
        return YES;
}


- (void)dateChanged
{
    NSDate *date = _eventDatePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    _eventDate.text = [dateFormat stringFromDate:date];
    _eventDatePicker.hidden=TRUE;
    [self save];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_eventTypes count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_eventTypes objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _eventType.text = [_eventTypes objectAtIndex:row];
    _eventPicker.hidden=TRUE;
    [self save];
}

/////////////////////////////////////////////////////////////////


#pragma mark - viewDidLoad



- (void)viewDidUnload
{
    self.library = nil;
    [super viewDidUnload];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return _imageReview;
}



- (void)viewWillAppear:(BOOL)animated   //needed ppfor the tabs
{
    [super viewWillAppear:animated];
    AppDelegate *appdeligate = [[UIApplication sharedApplication]delegate];
    context = [appdeligate managedObjectContext];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            // iphone5
            
            addressLabel.frame = CGRectMake(30.0, 250.0, 320.0, 100.0);
            _addressButton.frame = CGRectMake(0,250,320,85);
            _imageReview.frame = CGRectMake(0,121,320,382);
            reportTextView.frame = CGRectMake(0,44,320,377);
            
            _eventPicker.frame = CGRectMake(0,284,320,216);
            _eventDatePicker.frame = CGRectMake(0,243,320,216);
            
        }
        else{
            // iphone4s 
            _incidentList.frame = CGRectMake(0,40,320,328);
            _photoTable.frame = CGRectMake(0,40,320,326);
            reportTextView.frame = CGRectMake(0,44,320,297);
            mapView.frame = CGRectMake(0,44,320,420);
            _imageReview.frame = CGRectMake(0,119,320,300);
            addressLabel.frame = CGRectMake(20,206,300,78);
           locationBackground.frame = CGRectMake(0,30,320,390);
        
           incidentNumberLabel.frame = CGRectMake(14,46,153,21);
        
           _incidentNumber.frame = CGRectMake(169,46,79,21);
        
           _eventPicker.frame = CGRectMake(0,196,320,216);
           _eventDatePicker.frame = CGRectMake(0,155,320,216);
        
           addressLabel.frame = CGRectMake(30.0, 203.0, 320.0, 100.0);
           _addressButton.frame = CGRectMake(0,203,320,85);
            
           //spinner4.frame = CGRectMake(126,190,20,20);
            
            passcodeMessage.frame = CGRectMake(43,0,227,47);
            
            _pass1.frame = CGRectMake(37,80,50,40);
            _pass2.frame = CGRectMake(102,80,50,40);
            _pass3.frame = CGRectMake(167,80,50,40);
            _pass4.frame = CGRectMake(232,80,50,40);
            
        }
    }
    
    
    NSLog(@"viewWillAppear");
    NSIndexPath *selection;
    UITableView *tview;
    
    if (_incidentList)
    {
        //[_incidentList reloadData];
        //picturesURLArrayLoaded=false;
        tview = _incidentList;
        selection = [_incidentList indexPathForSelectedRow];
    }
    else if (_photoTable)
    {
        
        tview = _photoTable;
        selection = [_photoTable indexPathForSelectedRow];
    }
    
    if (selection) {
        [tview deselectRowAtIndexPath:selection animated:YES];
    }
    
    
    //[self viewDidLoad];
    NSLog(@"self.title=... %@", self.title);

    //load all varaibles to the screen
    _eventDate.text=currentIncident.eventDate;
    _incidentDescDetail.text=currentIncident.desc;
    uploadDate.text=currentIncident.uploadDate;
    _otherEvent.text=currentIncident.otherEventType;
    _eventType.text=currentIncident.eventType;
    drivenBy.text=currentIncident.drivenBy;
    _amount.text=currentIncident.amountSeized;
    _numberSubjects.text=currentIncident.numberOfSubjects;
    _creatDateLabel.text=currentIncident.createDate;
    _incidentNumber.text=currentIncident.number;
    
    _latitude.text=currentIncident.latitude;
    _longitude.text=currentIncident.longitude;
    addressLabel.text=currentIncident.address;
    
    if ([currentIncident.consentToSearch isEqualToString:@"yes"]){
        [consentToSearch setOn:YES animated:YES];
    } else{
        [consentToSearch setOn:NO animated:YES];
    }
    
    
    if ([currentIncident.arrested isEqualToString:@"yes"]){
        [arrested setOn:YES animated:YES];
    } else{
        [arrested setOn:NO animated:YES];
    }
    
    if ([currentIncident.vehicleSeized isEqualToString:@"yes"]){
        [vehicleSeized setOn:YES animated:YES];
    } else{
        [vehicleSeized setOn:NO animated:YES];
    }

    
    if ([self.title isEqualToString:@"Upload"]){
         NSString *eventType = [NSString stringWithFormat:@"%@ %@", currentIncident.eventType, currentIncident.otherEventType];
         report.text = [NSString stringWithFormat:@"i-ShaRE Report \nIncident Date:  %@\nOfficer:  %@\nAgency:  %@\nEvent Type:  %@\nDescription:  %@\nDriver Name:  %@\nAmount Seized:  %@ \nNumber Of Subjects:  %@\nConsent To Search:  %@\nArrested:  %@\nVehicle Seized:  %@\nLocation:  %@Latitude:  %@\nLongitude:  %@\nCreate Date:  %@\n",currentIncident.eventDate, currentLocalVariables.leo, currentLocalVariables.agency, eventType, currentIncident.desc,   currentIncident.drivenBy, currentIncident.amountSeized, currentIncident.numberOfSubjects, currentIncident.consentToSearch, currentIncident.arrested, currentIncident.vehicleSeized,currentIncident.address, currentIncident.latitude, currentIncident.longitude, currentIncident.createDate];
        report.text = [report.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    
    if ([self.title isEqualToString:@"Report"]) {
        leo.text=currentLocalVariables.leo;
        agency.text=currentLocalVariables.agency;
    }
    
    if ([self.title isEqualToString:@"Photos"]) {
        photoFolder=currentIncident.number;
        photoFolder = [NSString stringWithFormat:@"ishare-%@",photoFolder]; 
    }
    
    
    if ([self.title isEqualToString:@"View Image"]) {
        _viewImageDescription.text = currentPicture.descPhoto;
    }
    
    
    if (returnToTab!=nil) {
        [spinner2 stopAnimating];
        [spinner3 stopAnimating];
    }
    
    if (returnToTab==[NSNumber numberWithInteger:2]){
       self.tabBarController.selectedIndex = 2;
        returnToTab=nil;
    }

    if (_photoTable) {

        [_photoTable reloadData];
        NSLog(@"reload photoTable'''");
    }
    if (incidentList) {
        [incidentList reloadData];
        NSLog(@"reload reloadData'''");
    }

    if (_imageReview) {
         _imageReview.image=localImage;
    }
    
    
    // collect the photos
    NSLog(@"photos..count: %lu", (unsigned long)photos.count);
    
    if ([self.title isEqualToString:@"Location"]) {
        self.eventTypes = [[NSArray alloc] initWithObjects: @"", @"Traffic Stop", @"Jetway", @"Checkpoint",  @"Other", nil];
    }
    
    _version.text=self.getAppVersionNumber;
    
    if ([self.title isEqualToString:@"Incident List"]) {
        
        if (_incidentList) {
            [self loadIncidentData];
            NSLog(@"loadIncidentData....");
        }
    }
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");

    [spinner2 stopAnimating];
    [spinner3 stopAnimating];
    
    
    _creatDateLabel.text=currentIncident.createDate;
    if ([_eventDate.text isEqualToString:@""])
        _eventDate.text=currentIncident.createDate;
    
    //NSLog(@"agencyV: %@", agencyV);
                   
    _eventDate.tag =10;
    _eventType.tag =20;
    
    //if (currentLocalVariables.uploadEmail==nil)
    //    uploadEmailAddressV=@"info@customwebapps.info";  //default start email address
    
    //uploadEmailAddress.text=uploadEmailAddressV;
    

    if ([self.title isEqualToString:@"Settings"]) {
        leo.text=currentLocalVariables.leo;
        agency.text=currentLocalVariables.agency;
        uploadEmailAddress.text=currentLocalVariables.uploadEmail;
        
        NSLog(@"currentLocalVariables.enablePasscode: %@", currentLocalVariables.enablePasscode);
        if ([currentLocalVariables.enablePasscode isEqualToString:@"off"]){
            [enablePasscode setOn:NO animated:YES];
        } else{
            [enablePasscode setOn:YES animated:YES];
        }
    }

   
    if (mapView){
        [self loadMap];
        //[spinner4 stopAnimating];
    }

    AppDelegate *appdeligate = [[UIApplication sharedApplication]delegate];
        
    context = [appdeligate managedObjectContext];
    
    NSLog(@"self.title= __%@", self.title);

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goRight:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goLeft:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];

    
    if (newInstallation==nil){        //to get user confirmation to use GPS
        newInstallation=@"installed";
        locationManager = [[CLLocationManager alloc] init];
        [locationManager startUpdatingLocation];
    }
    
    
    [_eventDatePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    _eventDate.inputView = _eventDatePicker;
    _eventDatePicker.hidden=TRUE;
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor whiteColor], UITextAttributeTextColor,
//                                                       nil] forState:UIControlStateNormal];
//    
//    UIColor *titleHighlightedColor = [UIColor colorWithRed:153/255.0 green:92/255.0 blue:48/255.0 alpha:1.0];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       titleHighlightedColor, UITextAttributeTextColor,
//                                                       nil] forState:UIControlStateHighlighted];
    
    for(UIViewController *tab in  self.tabBarController.viewControllers)
        
    {
        [tab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont fontWithName:@"Helvetica" size:15.0], UITextAttributeFont, nil]
                                      forState:UIControlStateNormal];
    }
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _amount.inputAccessoryView = numberToolbar;
    _numberSubjects.inputAccessoryView = numberToolbar;
    
    if ([self.title isEqualToString:@"I-Share Login"]){  //and get the local variables
        
        [self verifyLogin];

        [self.navigationItem setHidesBackButton:YES];
        //if passcode blank then goto intro screen for user to set code then
        enteredPasscode = @"";
        _pass1.tag = 1;
        _pass2.tag = 2;
        _pass3.tag = 3;
        _pass4.tag = 4;
        _pass1.secureTextEntry = YES;
        _pass2.secureTextEntry = YES;
        _pass3.secureTextEntry = YES;
        _pass4.secureTextEntry = YES;
        [_pass1 becomeFirstResponder];
    }
    
    //Report stuff
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 650);
    scrollView.pagingEnabled=NO;
    scrollView.backgroundColor = [UIColor blackColor];
    
    _incidentDescDetail.layer.borderWidth = 1.0f;
    _incidentDescDetail.layer.borderColor = [[UIColor blackColor] CGColor];
    _incidentDescDetail.layer.cornerRadius = 8;

    

}



#pragma mark - save and delete

- (IBAction)addNewRecord:(id)sender {
    [spinner2 startAnimating];
  
    //the record creation happens in location

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}



- (IBAction)saveSettings:(id)sender {
    [self save];
    //[_incidentList reloadData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record Updated" message:[NSString stringWithFormat:@""] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)save{
    
    [spinner2 startAnimating];
    //because hese two fields are saved on a diffrent screen but can be temporlly changed 
    //NSLog(@"leoV: %@", leoV);
    //NSLog(@"leo.text: %@", leo.text);
//    if (leo){
//        if (![leo.text isEqualToString:currentLocalVariables.leo]) currentLocalVariables.leo=leo.text;
//        if (![agency.text isEqualToString:currentLocalVariables.agency]) currentLocalVariables.agency=agency.text;
//    }
    
    //NSLog(@"leoV: %@", leoV);
    //NSLog(@"leo.text: %@", leo.text);
    
    NSLog(@"saving data: uploadEmailAddress.text=%@", uploadEmailAddress.text);
    //if (uploadEmailAddress){  //on setting screen so update not insert
        
    if (leo) currentLocalVariables.leo=leo.text;
    if (agency) currentLocalVariables.agency=agency.text;
    if (uploadEmailAddress) currentLocalVariables.uploadEmail=uploadEmailAddress.text;
    
    if (enablePasscode){
            if (enablePasscode.on) {
                currentLocalVariables.enablePasscode=@"on";
            } else {
                currentLocalVariables.enablePasscode=@"off";
                currentLocalVariables.passcode=@"";        ///reset passcode
            }
    }

    //} else if (!_viewImageDescription){  //saving incident data only

     NSLog(@"self.incidentDescDetail.text: %@", self.incidentDescDetail.text);
     NSLog(@"currentIncident ID: %@", currentIncident.id);
            //saving the Incident table date only
            //list all fields here to save them
            
    if (_eventDate) currentIncident.eventDate=_eventDate.text;
    if (_incidentDescDetail) currentIncident.desc=_incidentDescDetail.text;
    if (uploadDate) currentIncident.uploadDate=uploadDate.text;
    if (_otherEvent) currentIncident.otherEventType=_otherEvent.text;
    if (_eventType) currentIncident.eventType=_eventType.text;
    if (drivenBy) currentIncident.drivenBy=drivenBy.text;
    if (_amount) currentIncident.amountSeized=_amount.text;
    if (_numberSubjects) currentIncident.numberOfSubjects=_numberSubjects.text;
    if (_incidentDescDetail) currentIncident.desc=_incidentDescDetail.text;
    
    
    if (consentToSearch){
        if (consentToSearch.on) {
            currentIncident.consentToSearch=@"yes";
        } else {
            currentIncident.consentToSearch=@"no";
        }
    }
    if (arrested){
        if (arrested.on) {
            currentIncident.arrested=@"yes";
        } else {
            currentIncident.arrested=@"no";
        }
    }
    if (vehicleSeized){
        if (vehicleSeized.on) {
            currentIncident.vehicleSeized=@"yes";
        } else {
            currentIncident.vehicleSeized=@"no";
        }
    }

    NSLog(@"self.title: %@", self.title);
    
    if ([self.title isEqualToString:@"View Image"]){
        
       if (_viewImageDescription)
                currentPicture.descPhoto = self.viewImageDescription.text;
    
        NSError *error;
        [context save:&error];
        
        picturesArray = [NSArray arrayWithArray:[currentIncident.pictures allObjects]];
        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"pictureNumber" ascending: NO];
        picturesArray = [[picturesArray sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortOrder]] mutableCopy];
        
        
    }
    
    NSLog(@"currentIncident.eventDate: %@", currentIncident.eventDate);
    //[self loadIncidentData];
    
    [spinner2 stopAnimating];
}



- (void)getNewIncidentNumber {
    entityDesc = [NSEntityDescription entityForName:@"Incident"  inManagedObjectContext:context];
    request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    [request setResultType:NSDictionaryResultType];
    //[request setResultType:NSDictionaryResultType];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"number"];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxNumber"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger16AttributeType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error = nil;
    //NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
    }
    else {
        if ([objects count] > 0) {
            NSNumber *currentIncidentId  = [[objects objectAtIndex:0] valueForKey:@"maxNumber"];
            incidentNumberInt  = [currentIncidentId intValue];
            incidentNumberInt++;
            currentIncidentId = [NSNumber numberWithInt:incidentNumberInt];
            NSLog(@"Next avaliable Number: %@", currentIncidentId);
        }
    }
}


#pragma mark - navigation
- (void)toList {
    anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"list"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight; //kCATransitionFromTop, kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:anotherVC animated:NO];
    
}

- (void)backToList {
    
    anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"list"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromTop, kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:anotherVC animated:NO];
    [_incidentList reloadData];
    
}

- (void)logOut {
    anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:anotherVC animated:NO];
}


- (void)loadIncidentData {          //called when adding or deleting
    NSLog(@"loadData in to array");

    //clear and reload
    NSError *error;
   
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Incident" inManagedObjectContext:context];
    
    request = [NSFetchRequest new];
    [request setEntity:entity];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    incidentArray = [[context executeFetchRequest:request error:&error] mutableCopy];
     
    NSLog(@"loadIncidentData incidentArray: %lu", (unsigned long)incidentArray.count);
}






- (IBAction)location:(id)sender {
    anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    //[self.navigationController pushViewController:anotherVC animated:NO];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromTop, kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:anotherVC animated:NO];
}


- (IBAction)list:(id)sender {
    
    [self backToList];

}

- (IBAction)toMap:(id)sender {
    
    //[spinner4 startAnimating];
    anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:anotherVC animated:NO];
}


#pragma mark - table view deligate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = 0;
    if (tableView==_incidentList)
    {
        count = 1;
    }
    else if (tableView==_photoTable)
    {
        count = 1;
    }
    
    return count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==_incidentList)
    {
        return 58;
    }
    else if (tableView==_photoTable)
    {
        return 76;
    }
    return 70;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    
    if (tableView==_incidentList)
    {
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorColor = [UIColor darkGrayColor];
        count = [incidentArray count];
    }
    else if (tableView==_photoTable)
    {
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorColor = [UIColor darkGrayColor];
        count = [picturesArray count];
    }
    return count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = @"??";
    
    if (tableView==_incidentList)
    {
        headerTitle = @"";
    }
    else if (_photoTable)
    {
        headerTitle = @"";
    }
    return headerTitle;
}


//here we save all data whenever you leave a screen
- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"viewWillDisappear");

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    

    myCell.textLabel.text = @"";
    
    if (tableView==_incidentList)
    {
        [spinner2 startAnimating];
        //currentIncidentId = [NSNumber numberWithInteger:[[listTitle objectAtIndex:indexPath.row] integerValue]];
        NSLog(@"indexPath.row = %ld", (long)indexPath.row);
        currentIncident = [incidentArray objectAtIndex:indexPath.row];
        //currentIncidentId = incident.id;
        
        NSLog(@"currentIncident.id = %@", currentIncident.id);
        
        [self readPicturesFromDB];

        
        anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        [self.navigationController pushViewController:anotherVC animated:YES];
    }
    else if (tableView==_photoTable)
    {
        //selectedPictureIndex = indexPath.row;   //for deletion
        
        currentPicture = [picturesArray objectAtIndex:indexPath.row];
        ALAsset *asset;
        for (id Aset in photos) {
            ALAssetRepresentation *rep = [Aset defaultRepresentation];
            //NSLog(@"picture.pictureURL...........: %@", currentPicture.pictureURL);
            //NSLog(@"rep.url.absoluteString.........: %@", rep.url.absoluteString);
            if ([currentPicture.pictureURL isEqualToString:rep.url.absoluteString])
            {
                asset = Aset;
            }
        }
     
        CGFloat scale  = 1;
        UIImageOrientation orientation = UIImageOrientationRight;
        
        localImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]
                                         scale:scale orientation:orientation];
        _imageReview.image = localImage;
        anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewImage"];
        [self presentViewController:anotherVC animated:YES completion:nil];
            
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView==_incidentList)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
       
        Incident *incident = [incidentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = incident.number;
        //NSLog(incident.number);
        //NSLog(@"incident.number: %@", incident.number);
        cell.detailTextLabel.text = incident.desc;
        
    }
    else if (tableView==_photoTable)
    {
        cell = [[UITableViewCell alloc]init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        
        //if(cell == NULL){
            
         //  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        //}
        
        Pictures *picture = [picturesArray objectAtIndex:indexPath.row];
        NSLog(@"picture.pictureURL: %@", picture.pictureURL);

        NSLog(@"photos...........: %lu", (unsigned long)photos.count);
        
        //loop over photos,  find one that has url = picture.pictureURL
        //ALAsset *asset;
        for (id Aset in photos) {
            ALAssetRepresentation *rep = [Aset defaultRepresentation];
             //NSLog(@"picture.pictureURL...........: %@", picture.pictureURL);
             //NSLog(@"rep.url.absoluteString.........: %@", rep.url.absoluteString);
            if ([picture.pictureURL isEqualToString:rep.url.absoluteString])
            {
                UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,76,76)];
                [myImageView setImage:[UIImage imageWithCGImage:[Aset thumbnail]]];
                [cell addSubview:myImageView];
            }
        }


        if ([cell.contentView subviews]){
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
        
        UILabel *myCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(82,0,207,71)];
        myCellLabel.text = picture.descPhoto;

        myCellLabel.numberOfLines = 3;
        
        [myCellLabel setLineBreakMode:NSLineBreakByWordWrapping];

        [myCellLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        
        [cell addSubview:myCellLabel];
        cell.textLabel.text = @"";
        
    }
    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}




- (NSString *) getAppVersionNumber;
{
    NSString *myVersion, *buildNum, *versText;
    
    myVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    buildNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    if (myVersion) {
    	if (buildNum)
    		//versText = [NSString stringWithFormat:@"%@ (%@)", myVersion, buildNum];
            versText = [NSString stringWithFormat:@"v%@", myVersion];
    	else
    		versText = [NSString stringWithFormat:@"v%@", myVersion];
    }
    else if (buildNum)
    	versText = [NSString stringWithFormat:@"v%@", buildNum];
    //NSLog(versText);
    return versText;
}




#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"list"];
    [self.navigationController pushViewController:anotherVC animated:NO];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    NSString *currentLongitude= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    NSString *currentLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    
    if (currentLocation != nil) {
        currentLongitude= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        currentLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            NSString *currentAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                              placemark.subThoroughfare, placemark.thoroughfare,
                              placemark.postalCode, placemark.locality,
                              placemark.administrativeArea,placemark.country];
            
            currentAddress = [currentAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            currentAddress = [currentAddress stringByReplacingOccurrencesOfString:@"United States" withString:@""];
            
            [self getNewIncidentNumber];
            NSString *num = [NSString stringWithFormat:@"%i",incidentNumberInt];
            if (num.length == 1)
                 num = [NSString stringWithFormat:@"00%d", incidentNumberInt];
            else if (num.length == 2)
                 num = [NSString stringWithFormat:@"0%d", incidentNumberInt];
            
            NSLog(@"num: %@", num);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, yyyy hh:mm"];
            //[formatter setDateStyle:NSDateFormatterMediumStyle];
            //currentCreateDate  = [formatter stringFromDate:[NSDate date]];
            //currentEventDate = currentCreateDate;
            
            currentIncident = (Incident *)[NSEntityDescription insertNewObjectForEntityForName:@"Incident" inManagedObjectContext:context];
            
            currentIncident.createDate = [formatter stringFromDate:[NSDate date]];
            currentIncident.eventDate = [formatter stringFromDate:[NSDate date]];
            currentIncident.number = num;
            currentIncident.id = [NSNumber numberWithInteger:incidentNumberInt];
            currentIncident.latitude = currentLatitude;
            currentIncident.longitude = currentLongitude;
            currentIncident.address = currentAddress;
            NSError *error;
            [context save:&error];  //save new record
            
            picturesArray = nil;
            
            //picturesURLArrayLoaded=false;
            
            //[self loadIncidentData];
            anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            CATransition* transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:anotherVC animated:NO];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}


#pragma mark - delete
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        if ([deleteFlag isEqualToString:@"deleteIncident"])
            [self deleteIncidentAction];
        if ([deleteFlag isEqualToString:@"deletePicture"]){
            [spinner2 stopAnimating];
            [self deletePictureAction];
        }
    }
}

- (IBAction)deleteIncident:(id)sender {
    deleteFlag = @"deleteIncident";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Delete?"
                          message:@""
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (IBAction)deletePicture:(id)sender {
    deleteFlag = @"deletePicture";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Remove Photo?"
                          message:@""
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Ok", nil];
    [alert show];
    
}




- (void)deletePictureAction
{
    
//    NSLog(@"photos..........,,,,: %lu", (unsigned long)photos.count);
//    NSLog(@"picturesArray..........,,,,: %lu", (unsigned long)picturesArray.count);
//    
//    NSMutableArray *toDelete = [NSMutableArray array];
//    for (id Aset in photos) {
//        ALAssetRepresentation *rep = [Aset defaultRepresentation];
//        if ([currentPicture.pictureURL isEqualToString:rep.url.absoluteString])
//        {
//            [toDelete addObject:Aset];
//        }
//    }
//    [photos removeObjectsInArray:toDelete];
    
    
    [context deleteObject:currentPicture];
    NSError *error;
    [context save:&error];
    
    [self readPicturesFromDB];
    
}


- (void)readPicturesFromDB
{
    picturesArray = [NSArray arrayWithArray:[currentIncident.pictures allObjects]];
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"pictureNumber" ascending: NO];
    picturesArray = [[picturesArray sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortOrder]] mutableCopy];
    
    ///reset photo array
    picturesURLArray = [[NSMutableArray alloc] init];
    photos = [[NSMutableArray alloc] init];
    for (id picture in picturesArray) {
        Pictures *testPic = picture;
        [picturesURLArray addObject:testPic.pictureURL];   //adding to a object we will use to filter the libaray photos
        NSLog(@"testPic.pictureURL = %@", testPic.pictureURL);
    }
    
    ALAssetsLibrary *al = [ViewController defaultAssetsLibrary];
    __block NSMutableArray *collector = [[NSMutableArray alloc] init];
    //[al assetForURL:[NSURL URLWithString:picture.pictureURL] resultBlock:^(ALAsset *asset) {
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop1)
     {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop2)
          {
              if (asset) {
                  //ALAssetRepresentation *rep = [asset defaultRepresentation];
                  //NSString *fileURL = rep.url.absoluteString;
                  if ([picturesURLArray containsObject: [asset defaultRepresentation].url.absoluteString]){
                      [collector addObject:asset];
                      //*stop2 = YES;
                  }
              }
          }];
         photos = collector;
         
         //NSLog(@"self.photos..........,,,,: %lu", (unsigned long)photos.count);
         picturesArray = [NSArray arrayWithArray:[currentIncident.pictures allObjects]];
         NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"pictureNumber" ascending: NO];
         picturesArray = [[picturesArray sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortOrder]] mutableCopy];
         
         //NSLog(@"photos..........,,,,: %lu", (unsigned long)photos.count);
         //NSLog(@"picturesArray..........,,,,: %lu", (unsigned long)picturesArray.count);
         [spinner2 stopAnimating];
         [self dismissViewControllerAnimated:NO completion:nil];
         *stop1 = YES;
     }
                    failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
     ];
}



- (void)deleteIncidentAction
{
    [context deleteObject:currentIncident];
    NSError *error;
    [context save:&error];
    NSLog(@"%d records(s) deleted", 1);

    [self backToList];
}
    
    
    
    
#pragma mark - camera methods
    
    
    
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}



-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [spinner2 stopAnimating];
    [spinner3 stopAnimating];
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)chooseExisting:(id)sender {
    
    picker2 = [[UIImagePickerController alloc]init];
    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker2 setDelegate:self];
   
    [self presentViewController:picker2 animated:YES completion:nil];
    
}

-(IBAction)takePhoto:(id)sender
{
    [spinner2 startAnimating];
    [spinner3 startAnimating];
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
    
    //   anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photos"];
    //   [self.navigationController pushViewController:anotherVC animated:NO];
}


- (void)imagePickerController:(UIImagePickerController *)pickerV didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [pickerV dismissViewControllerAnimated:NO completion:nil];
    

    UIImage* imageV = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    //ALAssetsLibrary *al = [ViewController defaultAssetsLibrary];
    [self saveImageLocal:imageV toAlbum:photoFolder withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        } else {
            
            //NSLog(@"no photo saving error ");
            //NSLog(@"assetAbsoluteString save this to file: %@", assetAbsoluteString);
            //[self findLargeImage];
                        
            ALAssetsLibrary *al = [ViewController defaultAssetsLibrary];
            [al assetForURL:[NSURL URLWithString:assetAbsoluteString] resultBlock:^(ALAsset *asset) {
                //CGFloat scale  = 1;
                //UIImageOrientation orientation = UIImageOrientationUp;
                //localImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];

                Pictures *picture = (Pictures *)[NSEntityDescription insertNewObjectForEntityForName:@"Pictures" inManagedObjectContext:context];
                
                picture.pictureURL = assetAbsoluteString;
                picture.descPhoto = @"";
                
                if (photos==nil)
                    photos = [[NSMutableArray alloc] init];
                //also add to the photos array
                [photos insertObject:asset atIndex:0];
                
                
                //picturesArray = [NSArray arrayWithArray:[currentIncident.pictures allObjects]];
                NSNumber *nextPictureNum = [NSNumber numberWithInt:picturesArray.count];
                int nextValue = [nextPictureNum intValue];
                nextValue++;
                picture.pictureNumber = [NSNumber numberWithInt:nextValue];
                NSLog(@"picture.pictureNumber: %ld", (long)picture.pictureNumber);  //for order by
                

                [[currentIncident mutableSetValueForKey:@"pictures"] addObject:picture];  //adding the new picture object here
                
                NSError *error;
                [context save:&error];  //save new record
                
                //NSLog(@"photos..........1,,,,: %lu", (unsigned long)photos.count);
                //NSLog(@"picturesArray..........2,,,,: %lu", (unsigned long)picturesArray.count);

                
                picturesArray = [NSArray arrayWithArray:[currentIncident.pictures allObjects]];
                NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"pictureNumber" ascending: NO];
                picturesArray = [[picturesArray sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortOrder]] mutableCopy];

          
                NSLog(@"created new picture record with id=: %@", nextPictureId);
                
    
                returnToTab = [NSNumber numberWithInt:2];
                anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
                [self.navigationController pushViewController:anotherVC animated:NO];   
                
            }
             
               failureBlock:^(NSError *error) {
                   NSLog(@"Asset fetch failed: %@",error);
               }];
            
        }
    }];
}


- (void)getNewPictureNumber {
    entityDesc = [NSEntityDescription entityForName:@"Pictures" inManagedObjectContext:context];
    request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    [request setResultType:NSDictionaryResultType];
    //[request setResultType:NSDictionaryResultType];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"id"];
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxNumber"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger16AttributeType];
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error = nil;
    //NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
    }
    else {
        if ([objects count] > 0) {
            nextPictureId  = [[objects objectAtIndex:0] valueForKey:@"maxNumber"];
            int numberInt  = [nextPictureId intValue];
            numberInt++;
            nextPictureId = [NSNumber numberWithInt:numberInt];
            NSLog(@"Next avaliable nextPictureId: %@", nextPictureId);
        }
    }
}





-(void)saveImageLocal:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    //write the image data to the assets library (camera roll)
    ALAssetsLibrary *al = [ViewController defaultAssetsLibrary];
    [al writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                     completionBlock:^(NSURL* assetURL, NSError* error) {
                         
                         //error handling
                         if (error!=nil) {
                             completionBlock(error);
                             return;
                         }
                         
                         assetAbsoluteString=assetURL.absoluteString;
                         [al addAssetURL: assetURL
                                 toAlbum:albumName
                     withCompletionBlock:completionBlock];
                         
                     }];
}



- (IBAction)uploadReport:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        [spinner2 startAnimating];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"i-ShaRE Report"];
        //NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:currentLocalVariables.uploadEmail, nil];
        
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = report.text;

        NSLog(@"picturesArray.count = %lu", (unsigned long)picturesArray.count);
        NSLog(@"photos.count = %lu", (unsigned long)photos.count);
        
        //if (picturesArray.count!=photos.count){

            //[alert2 show];
            
        //}
    
        //[ObratString appendString:@"\n"];
        
        
        emailBody = [NSString stringWithFormat:@"%@ %@ %@", emailBody, @"Photo count: ", [NSString stringWithFormat:@"%d", picturesArray.count]];
        //emailBody = [NSString stringWithFormat:@"%@ %@ %@ ", emailBody, @"Photo count: ", [NSString stringWithFormat:@"%d", picturesArray.count], [NSString stringWithFormat:@"%d", photos.count ] ];
        
        for (Pictures *picture in picturesArray) {
            for (id Aset in photos) {
                ALAssetRepresentation *rep = [Aset defaultRepresentation];
                if ([picture.pictureURL isEqualToString:rep.url.absoluteString])
                {
                    UIImageView *myImageView = [[UIImageView alloc] init];
                    [myImageView setImage:[UIImage imageWithCGImage:[Aset thumbnail]]];
                    
                    CGImageRef iref = [rep fullScreenImage];
                    UIImage *myImage;
                    if (iref) {
                        myImage= [UIImage imageWithCGImage:iref];
                    }
                    NSData *imageData = UIImageJPEGRepresentation(myImage, 0.5);
                    [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
                    
                    emailBody = [NSString stringWithFormat:@"%@ \n%@%@", emailBody, @"Photo: ", picture.descPhoto ];
                    //[emailBody appendString:@"\nPhoto: "];
                    //[emailBody appendString:picture.descPhoto];
                    
                    NSLog(@"picture.descPhoto = %@", picture.descPhoto);
                    NSLog(@"emailBody = %@", emailBody);
                }
            }
        }
        
        [mailer setMessageBody:emailBody isHTML:NO];
        //[self presentViewController:mailer animated:YES];
        [self presentViewController:mailer animated:NO completion:nil];
        
    }
    else
    {
        [spinner2 stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [spinner2 stopAnimating];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:{
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, yyyy hh:mm"];
            uploadDate.text  = [formatter stringFromDate:[NSDate date]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Report Sent"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            break;}
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (IBAction)loadMap
{
    //mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.mapType = MKMapTypeHybrid;
   
    NSLog(@"currentLatitude = %f", [currentIncident.latitude doubleValue]);
    NSLog(@"currentLongitude = %f", [currentIncident.longitude doubleValue]);
    
    //CLLocationCoordinate2D coord = {latitude: [currentIncident.latitude doubleValue], longitude: [currentIncident.longitude doubleValue]};
    
    CLLocationCoordinate2D coord = {.latitude =  [currentIncident.latitude doubleValue], .longitude =  [currentIncident.longitude doubleValue]};
    
    MKCoordinateSpan span = {.latitudeDelta =  0.002, .longitudeDelta =  0.002};
    MKCoordinateRegion region = {coord, span};
    
    [mapView setRegion:region];
    
    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[currentIncident.latitude doubleValue] longitude:[currentIncident.longitude doubleValue]];

    _coords = LocationAtual.coordinate;
    MKCoordinateRegion region1;
    MKCoordinateSpan span1;
    span1.latitudeDelta=.006;
    span1.longitudeDelta=.006;
    
    region1.span=span1;
    region1.center=_coords;
    AddressAnnotation *addAnnotation1;
    if(addAnnotation1 != nil) {
        [mapView removeAnnotation:addAnnotation1];
        addAnnotation1 = nil;
    }
    addAnnotation1 = [[AddressAnnotation alloc] initWithCoordinate:_coords];
    [mapView addAnnotation:addAnnotation1];
    [mapView setRegion:region1 animated:TRUE];
    [mapView regionThatFits:region1];
    [mapView setMapType:MKMapTypeHybrid];
    [mapView selectAnnotation:addAnnotation1 animated:NO];
}



- (void)verifyLogin {
    //Verify login
    
    NSError *error;
    
    entityDesc = [NSEntityDescription entityForName:@"LocalVarables" inManagedObjectContext:context];
    
    request = [NSFetchRequest new];
    [request setEntity:entityDesc];
    
    localVariablesArray = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if(localVariablesArray.count==0)
    {
        //this code only runs once!
        currentLocalVariables = (LocalVarables *)[NSEntityDescription insertNewObjectForEntityForName:@"LocalVarables" inManagedObjectContext:context];
        currentLocalVariables.passcode = @"";
        currentLocalVariables.enablePasscode = @"on";
        currentLocalVariables.uploadEmail = @"info@customwebapps.info";
        NSError *error;
        [context save:&error];  //save passcode
    } else {
        currentLocalVariables = [localVariablesArray objectAtIndex:0];
    }
    
    
//    NSString *message = [NSString stringWithFormat:@"%@%@",@"passcode is ", currentLocalVariables.passcode];
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"xxx" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
    
    if([currentLocalVariables.passcode isEqualToString:@""])
    {
        if ([currentLocalVariables.enablePasscode isEqualToString:@"off"])
            [self toList];
        _passcodeLabel.text=@"Welcome to i-ShaRE  Create your Passcode";
    }else{
        currentLocalVariables = [localVariablesArray objectAtIndex:0];
        _passcodeLabel.text=@"Enter Your Passcode";
        if ([currentLocalVariables.enablePasscode isEqualToString:@"off"])
            [self toList];
    }

    //[self verifyPasscode];
}


- (void)verifyPasscode {
    
    //(([enteredPasscode isEqualToString:@"3333"]) && (![enteredPasscode isEqualToString:currentLocalVariables.passcode]))
    
    //if they pick admid passcode then all is normal unless they try a diffrent passcode rather than an error
    //    message they will be let in and notified that their new passcode is what they just entered
    
    if ([enteredPasscode isEqualToString:@"3333"])  //administrative passcode
    {
        //currentLocalVariables.passcode = @"";
        //currentLocalVariables.enablePasscode = @"on";
        currentLocalVariables.passcode = enteredPasscode;
        NSError *error;
        [context save:&error];  //save passcode
        [self toList];

    } else if([currentLocalVariables.passcode isEqualToString:@""]) {
        if(enteredPasscode.length==4){
                                                
            currentLocalVariables.passcode = enteredPasscode;
            currentLocalVariables.enablePasscode = @"on";
            NSError *error;
            [context save:&error];  //save passcode
            
            NSString *message = [NSString stringWithFormat:@"%@%@",@"Please remember your passcode is ", currentLocalVariables.passcode];
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Welcome" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            
            [self toList];
        } else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Invalid Passcode" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
        
    } else if ([currentLocalVariables.passcode isEqualToString:enteredPasscode]){
        currentLocalVariables = [localVariablesArray objectAtIndex:0];
        [self toList];
    } else {
        enteredPasscode = @"";
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Invalid Passcode" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [_pass1 becomeFirstResponder];
        _pass1.text = @"";
        _pass2.text = @"";
        _pass3.text = @"";
        _pass4.text = @"";
    }
}


- (IBAction)goRight:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
}

- (IBAction)goLeft:(id)sender
{
    if ([self.title isEqualToString:@"Location"]) {
        [self backToList];
    } else {
        
        NSUInteger selectedIndex = [self.tabBarController selectedIndex];
        
        [self.tabBarController setSelectedIndex:selectedIndex - 1];
        
    }
}

- (IBAction)closeModelView:(id)sender {

//    returnToTab = [NSNumber numberWithInt:2];
//    
//    anotherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
//    //[self.navigationController pushViewController:anotherVC animated:NO];
//    
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush; //kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    transition.subtype = kCATransitionFromBottom; //kCATransitionFromTop, kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController pushViewController:anotherVC animated:NO];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)saveFromSwitch:(id)sender {
    [self save];
}
@end
