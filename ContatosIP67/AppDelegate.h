//
//  AppDelegate.h
//  ContatosIP67
//
//  Created by ios2736 on 12/05/05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

- (void) carregaDoPlist;

@end
