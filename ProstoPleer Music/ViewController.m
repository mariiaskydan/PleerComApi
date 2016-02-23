//
//  ViewController.m
//  ProstoPleer Music
//
//  Created by Mariya Dychko on 17.02.16.
//  Copyright © 2016 Simple Project. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


@end

@implementation ViewController


@synthesize pickerData;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self requestMaking];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.pickerData  = [[NSArray alloc] initWithObjects:
                        @"One Week",
                        @"One Month",
                        @"Three Month",
                        @"Half Year",
                        @"One Year",
                        nil];
    self.periodPicker.delegate = self;
    self.periodPicker.dataSource = self;

    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.periodPicker = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PickerDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.period = [NSString stringWithFormat:@"%d", row++];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.pickerData count];
}

#pragma mark - Actoins
- (IBAction)rusLanguage:(id)sender {

    self.language = @"ru";
    
    [self.russianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.englishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)engLenguage:(id)sender {
    
    self.language = @"en";
    
    [self.englishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.russianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)showTC:(id)sender {
    if(!_language){
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Check" message:@"Did you choose language and period?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [self performSegueWithIdentifier:@"showTableController" sender:nil];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTableController"])
    {
        if (!self.period) {
            self.period = @"1";
        }
    
    NSDictionary *sende = @{
                             @"period" : self.period,
                             @"language" : self.language };
    
       TableAndSearchVC *destinationVC = segue.destinationViewController;
    
    destinationVC.incomingData = [(NSDictionary*)sende copy];
    }
}

-(void) requestMaking {
    NSString *clientID = @"119348";
    NSString *secret = @"123456789";
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", clientID, secret];
    NSData * authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *credentials = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.pleer.com/token.php"]];
    request.HTTPMethod = @"POST";
    [request addValue:credentials forHTTPHeaderField: @"Authorization"];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[@"grant_type=client_credentials" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                             error:&error];
                                      
                                      NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                      [ud setObject:json[@"access_token"] forKey:@"token"];
                                  }];
    [task resume];
    
   
    
}
@end
