//
//  ViewController.h
//  ProstoPleer Music
//
//  Created by Mariya Dychko on 17.02.16.
//  Copyright © 2016 Simple Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>


#import "TableAndSearchVC.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *periodPicker;

@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSString *period;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSDictionary *incomingData;



@property (strong, nonatomic) IBOutlet UIButton *russianBtn;
@property (strong, nonatomic) IBOutlet UIButton *englishBtn;

- (IBAction)rusLanguage:(id)sender;
- (IBAction)engLenguage:(id)sender;
- (IBAction)showTC:(id)sender;

@end

