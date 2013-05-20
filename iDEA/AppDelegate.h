//
//  AppDelegate.h
//  iDEA
//
//  Created by Trey Hambrick on 4/27/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *databasePath;
    UIStoryboard *mainStoryboard;
    ViewController *controller;
    UINavigationController *navController;
}
@property (nonatomic,retain) UINavigationController *navController;
@property (nonatomic,retain) ViewController *controller;

@property (retain,nonatomic) NSString *databasepath;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *password;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
