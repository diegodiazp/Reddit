//
//  AppDelegate.h
//  Rappi
//
//  Created by Diego Diaz on 4/03/17.
//  Copyright © 2017 Diego Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

