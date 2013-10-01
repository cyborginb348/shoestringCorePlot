//
//  AppDelegate.h
//  Shoestring
//
//  Created by mark on 3/09/13.
//  Copyright (c) 2013 mark. All rights reserved.
//  tseting

#import <UIKit/UIKit.h>

#import "HomeViewController.h"
#import "TodayViewController.h"
#import "FindViewController.h"
#import "HistoryViewController.h"
#import "GraphMyExpensesViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
