//
//  TableAndSearchVC.h
//  ProstoPleer Music
//
//  Created by Mariya Dychko on 18.02.16.
//  Copyright © 2016 Simple Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayTableViewCell.h"


@interface TableAndSearchVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) NSDictionary *incomingData;


@end
