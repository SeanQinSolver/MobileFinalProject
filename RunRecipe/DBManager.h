//
//  DBManager.h
//  RunRecipe
//
//  Created by Chuanyu Chen on 7/24/16.
//  Copyright © 2016 Team1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@end
