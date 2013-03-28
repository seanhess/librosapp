//
//  UserService.m
//  Libros
//
//  Created by Sean Hess on 1/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "UserService.h"
#import "ObjectStore.h"
#import "User.h"
#import "Book.h"
#import "NSObject+Reflection.h"
#import "FileService.h"
#import "NSArray+Functional.h"

#import <RestKit.h>

#define FONT_SIZE_KEY @"fontSize"
#define FONT_FACE_KEY @"fontFace"
#define ALL_BOOKS_PURCHASED_KEY @"purchasedAllBooks"
#define FIRST_LAUNCH_KEY @"firstLaunchBooks"

@interface UserService ()
@property (strong, nonatomic) Book * book;
@property (nonatomic) NSInteger activeDownloads;

@end

@implementation UserService

+ (UserService *)shared
{
    static UserService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserService alloc] init];
        [instance initMappings];
        [instance initMainUser];
    });
    return instance;
}

- (void)initMappings {
    RKEntityMapping *bookMapping = [ObjectStore.shared mappingForEntityForName:@"User"];
    [bookMapping setIdentificationAttributes:@[@"userId"]];
    [bookMapping addAttributeMappingsFromArray:[_User propertyNames]];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping pathPattern:@"/books" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
}

- (void)initMainUser {

    // There's only one in the whole system!
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetch.fetchLimit = 1;
    NSError * error = nil;
    NSArray * users = [ObjectStore.shared.context executeFetchRequest:fetch error:&error];
    
    if (users.count) {
        self.main = users[0];
    }
    
    else {
        User * user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:ObjectStore.shared.context];
        user.userId = @"main";
        self.main = user;
    }
}



// USER PREFERENCES

-(ReaderFont)fontFace {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FONT_FACE_KEY];
}

-(void)setFontFace:(ReaderFont)fontFace {
    [[NSUserDefaults standardUserDefaults] setInteger:fontFace forKey:FONT_FACE_KEY];
}

-(NSInteger)fontSize {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FONT_SIZE_KEY];
}

-(void)setFontSize:(NSInteger)fontSize {
    [[NSUserDefaults standardUserDefaults] setInteger:fontSize forKey:FONT_SIZE_KEY];
}

-(void)purchasedAllBooks {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ALL_BOOKS_PURCHASED_KEY];
}

-(BOOL)hasPurchasedBook:(Book*)book {
    return book.purchasedValue || [[NSUserDefaults standardUserDefaults] boolForKey:ALL_BOOKS_PURCHASED_KEY];
}

-(BOOL)hasActiveDownload {
    return (self.activeDownloads > 0);
}

// none of them have any files!
// have to load them too!
-(void)addBook:(Book *)book {
    NSLog(@"Adding Book %@", book.title);
    book.purchasedValue = YES;
    book.downloadedValue = 0.01; // want to start at a little, meaning it is currently downloading
    self.activeDownloads++;
    
    // We need to load the files for the book
    [[FileService shared] loadFilesForBook:book.bookId cb:^{
        [FileService.shared
            downloadFiles:[FileService.shared byBookId:book.bookId]
            progress:^(float percent) {
                book.downloadedValue = percent;
            }
            complete:^() {
                book.downloadedValue = 1.0;
                self.activeDownloads--;
            }
        ];
    }];
}

// adds ALL specified books, one at a time.
// I need an easy way to carry out a queue of things, one at a time.
// the problem is operations don't even tell you when they are done, not easily
// Try starting all of them at once
-(void)addBooks:(NSArray*)books {
    [books forEach:^(Book*book) {
        [self addBook:book];
    }];
}

-(void)archiveBook:(Book *)book {
    book.purchasedValue = YES;
    book.downloadedValue = 0.0;
    FileService * fs = [FileService shared];
    [fs removeFiles:[fs byBookId:book.bookId]];
}


-(NSFetchRequest*)libraryBooks {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    // see archiveBook. If it is being downloaded, downloaded is set to 0.01
    // set to 0.0 when they archive
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"purchased == YES AND downloaded > 0.0"];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[descriptor];
    return fetchRequest;
}





-(BOOL)hasFirstLaunchBooks {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FIRST_LAUNCH_KEY];
}

-(void)setHasFirstLaunchBooks {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_LAUNCH_KEY];
}

-(void)checkRestartDownload:(Book*)book {
    // NSLog(@"RESTARTING Check: %@", book.title);
    if (book.purchasedValue && 0.0 < book.downloadedValue && book.downloadedValue < 1.0 && !self.hasActiveDownload) {
        NSLog(@"RESTARTING Download: %@", book.title);
        [self addBook:book];
    }
}



@end
