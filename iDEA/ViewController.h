//
//  ViewController.h
//  iDEA
//
//  Created by Trey Hambrick on 4/27/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MessageUI.h>
#import "LocalVarables.h"
#import "Pictures.h"
#import "Incident.h"
#import "tableViewCell.h"
//#import <Quartz/Quartz.h>


typedef void(^SaveImageCompletion)(NSError* error);

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);


@interface ViewController : UIViewController <UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate, MFMailComposeViewControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate,CLLocationManagerDelegate>
{
    
    IBOutlet UILabel *passcodeMessage;
    
    
    
    
    UIImagePickerController *picker;
    UIImagePickerController *picker2;
    UIImage *image;

    IBOutlet UITableView *incidentList;

	NSMutableArray *photoAssets;
    
    NSString *assetAbsoluteString;
    
    IBOutlet UIActivityIndicatorView *spinner2;

    IBOutlet UISwitch *enablePasscode;
    
    IBOutlet UIActivityIndicatorView *spinner3;
    
    
    IBOutlet UITextField *drivenBy;
    
    IBOutlet UISwitch *consentToSearch;
    
    IBOutlet UISwitch *arrested;
    
    IBOutlet UIImageView *locationBackground;

    IBOutlet UISwitch *vehicleSeized;
    
    
    IBOutlet UITextField *numberSubjects;
    IBOutlet UILabel *incidentNumberLabel;
    
    
    IBOutlet UITextField *uploadDate;
    
    IBOutlet UIScrollView *scrollView;
    
    
 
    IBOutlet UILabel *addressLabel;

    IBOutlet UITextView *reportTextView;
    IBOutlet MKMapView *mapView;
    IBOutlet UITextView *report;
    IBOutlet UITextField *leo;
    IBOutlet UITextField *agency;
    IBOutlet UITextField *uploadEmailAddress;
}
- (IBAction)saveFromSwitch:(id)sender;

//@property (nonatomic, strong) NSArray *photos;

//typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
//typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@property CLLocationCoordinate2D coords;


@property (nonatomic, strong) NSString *assetAbsoluteString;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@property (strong, atomic) ALAssetsLibrary* library;
@property (strong, nonatomic) IBOutlet UILabel *passcodeLabel;


@property (nonatomic, retain) NSArray *eventTypes;

//- (void)logOut;
@property (strong, nonatomic) IBOutlet UITableView *incidentList;

@property (strong, nonatomic) IBOutlet UITextField *pass1;
@property (strong, nonatomic) IBOutlet UITextField *pass2;
@property (strong, nonatomic) IBOutlet UITextField *pass3;
@property (strong, nonatomic) IBOutlet UITextField *pass4;

- (IBAction)changedValue:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *version;
@property (strong, nonatomic) IBOutlet UITextField *amount;

- (IBAction)deletePicture:(id)sender;

- (IBAction)saveSettings:(id)sender;



@property(nonatomic, readonly) UIInterfaceOrientation interfaceOrientation;


- (IBAction)takePhoto:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *incidentNumber;


@property (strong, nonatomic) IBOutlet UITextView *incidentDescDetail;

- (IBAction)deleteIncident:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property (strong, nonatomic) IBOutlet UILabel *longitude;


@property (strong, nonatomic) IBOutlet UIButton *addressButton;


@property (strong, nonatomic) IBOutlet UITextField *numberSubjects;

//- (IBAction)swipRight1:(id)sender;
//
//- (IBAction)swipLeft1:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *eventType;
@property (strong, nonatomic) IBOutlet UIPickerView *eventPicker;
@property (strong, nonatomic) IBOutlet UILabel *creatDateLabel;

@property (strong, nonatomic) IBOutlet UIDatePicker *eventDatePicker;
@property (strong, nonatomic) IBOutlet UITextField *eventDate;
@property (strong, nonatomic) IBOutlet UITextField *otherEvent;

- (IBAction)location:(id)sender;

- (IBAction)goRight:(id)sender;
- (IBAction)goLeft:(id)sender;

- (IBAction)basic:(id)sender;
- (IBAction)details:(id)sender;
- (IBAction)remarks:(id)sender;
- (IBAction)photos:(id)sender;
- (IBAction)upload:(id)sender;
- (IBAction)list:(id)sender;

- (IBAction)toMap:(id)sender;


@property (strong, nonatomic) IBOutlet UITableView *photoTable;
@property (strong, nonatomic) IBOutlet UITextField *viewImageDescription;


@property (strong, nonatomic) IBOutlet UIImageView *imageReview;

- (IBAction)addNewRecord:(id)sender;

- (IBAction)uploadReport:(id)sender;

- (IBAction)closeModelView:(id)sender;



@end
