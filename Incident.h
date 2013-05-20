//
//  Incident.h
//  i-ShaRE
//
//  Created by Trey Hambrick on 5/12/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pictures;

@interface Incident : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * amountSeized;
@property (nonatomic, retain) NSString * arrested;
@property (nonatomic, retain) NSString * consentToSearch;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * drivenBy;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * modifyDate;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * numberOfSubjects;
@property (nonatomic, retain) NSString * otherEventType;
@property (nonatomic, retain) NSString * uploadDate;
@property (nonatomic, retain) NSString * vehicleSeized;
@property (nonatomic, retain) NSString * eventDate;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface Incident (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(Pictures *)value;
- (void)removePicturesObject:(Pictures *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
