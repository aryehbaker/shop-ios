//
//  FavList.m
//  Shoprose
//
//  Created by vnidev on 5/17/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "FavListViewController.h"

@interface FavListViewController()
{
    UIScrollView *ctnt;
    NSMutableArray *indexs;
}

@end

@implementation FavListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *top = [[UIImageView alloc] initWithFrame:Frm(0,self.nav.endY, self.view.w, 40)];
    top.backgroundColor = [@"#DBDBDB" hexColor];
    [self.view addSubview:top];
    
    [VINet get:@"/api/categories/mine" args:nil target:self succ:@selector(showItems:) error:@selector(showErr:) inv:self.view];
    
    ctnt = [[UIScrollView alloc] initWithFrame:Frm(top.x, top.endY, self.view.w,self.view.h - 70 - 40)];

    UIView *btn = [[UIView alloc] initWithFrame:Frm(0, ctnt.endY, self.view.w, 70)];
    
    UIButton *cycle = [UIButton buttonWithType:UIButtonTypeCustom];
    cycle.frame = Frm(30, 10, 50, 50);
    cycle.layer.borderWidth = 1;
    cycle.layer.cornerRadius = 25;
    cycle.layer.borderColor = [@"#FC484D" hexColor].CGColor;
    cycle.backgroundColor = [UIColor whiteColor];
    [cycle setTitleColor:[@"#FC484D" hexColor] forState: UIControlStateNormal ];
    cycle.titleLabel.font = Bold(20);
    [cycle setTitle:Lang(@"index_skip") selected:Lang(@"index_skip")];
    [cycle addTarget:self action:@selector(skipThis:)];
    [btn addSubview:cycle];
    
    UIButton *finish = [UIButton buttonWithType:UIButtonTypeSystem];
    finish.backgroundColor = [@"#EDEDED" hexColor];
    finish.layer.borderWidth = 1;
    finish.layer.cornerRadius = 25;
    finish.layer.borderColor = [@"#A9A9A9" hexColor].CGColor;
    finish.frame = Frm(cycle.endX+15, 10, 200, 50);
    [finish setTitle:Lang(@"index_finish") selected:Lang(@"index_finish")];
    [finish setTitleColor:[@"#464646" hexColor] forState:UIControlStateNormal];
    finish.titleLabel.font = Regular(25);
    [finish addTarget:self action:@selector(gotomain:)];
    [btn addSubview:finish];
    
    [self.view addSubview:btn];
}

- (void)showErr:(id)value
{
    [self showAlertError:value];
}

- (void)skipThis:(UIButton *)btn {
    if (isEn) {
        [self popTo:@"VIAroundMeViewController"];
    }
    if (isHe) {
         [self popTo:@"VINearByViewController"];
    }
}

- (void) showItems:(NSArray *)values{
    
    indexs = [values mutableCopy];
    
    int width = (self.view.w - 4) / 3;
    int x,y,oh=0,h=0;
    for(int i=0;i< values.count;i++){
        x = (i % 3) * width;
        y = (i / 3) * width;
        int of = i % 3 == 0 ?  0 : (i % 3)== 1 ? 2 : 4;
        if(i%3 == 0)
            oh += 2;
        UIButton *dk = [[UIButton alloc] initWithFrame:Frm(x+of, y+oh, width, width)];
        dk.tag = i;
        NSDictionary *d = [values objectAtIndex:i];
        EGOImageView *img = [[EGOImageView alloc] init];
        img.placeholderImage = [@"no_pic.png" image];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.imageURL = [NSURL URLWithString:[d stringValueForKey:@"PictureUrl"]];
        img.frame = Frm((width-65)/2,(width-65)/2-8,65,65);
        [dk addSubview:img];
        
        if (i % 3 !=2) {
            UIView *lt3 = [[UIView alloc] initWithFrame:Frm(dk.w-2, 0, 1, dk.h)];
            lt3.backgroundColor = [@"#c0c0c0" hexColor];
            UIView *lt4 = [[UIView alloc] initWithFrame:Frm(dk.w-1, 0, 1, dk.h)];
            lt4.backgroundColor = [@"#ffffff" hexColor];
            [dk addSubview:lt3];
            [dk addSubview:lt4];
        }
        
        [dk setTitle:[d stringValueForKey:@"Name"] selected:[d stringValueForKey:@"Name"]];
        [dk setTitleColor:[@"ff4747" hexColor] forState:UIControlStateNormal];
        [dk setTitleColor:[@"ffffff" hexColor] forState:UIControlStateSelected];
        
        dk.titleEdgeInsets = UIEdgeInsetsMake(75, 5, 2, 5);
        dk.titleLabel.font = Black(15);
        dk.selected = [d boolValueForKey:@"IsMarked" defaultValue:NO];
        [dk setBackgroundColor:dk.selected ? [@"#ff4747" hexColor] : [UIColor clearColor]] ;
        [ctnt addSubview:dk];
        [dk addTarget:self action:@selector(dochecked:)];
        h = dk.endY;
        
        if (i == 0) {
            UIView *lt = [[UIView alloc] initWithFrame:Frm(0, 0, self.view.w, 1)];
            lt.backgroundColor = [@"#c0c0c0" hexColor];
            UIView *lt2 = [[UIView alloc] initWithFrame:Frm(0, 1, self.view.w, 1)];
            lt2.backgroundColor = [@"#ffffff" hexColor];
            [ctnt addSubview:lt];
            [ctnt addSubview:lt2];
        }
        
        if (i%3 == 0) {
            UIView *lt = [[UIView alloc] initWithFrame:Frm(0, h, self.view.w, 1)];
            lt.backgroundColor = [@"#c0c0c0" hexColor];
            UIView *lt2 = [[UIView alloc] initWithFrame:Frm(0, h+1, self.view.w, 1)];
            lt2.backgroundColor = [@"#ffffff" hexColor];
            [ctnt addSubview:lt];
            [ctnt addSubview:lt2];
        }
        
    }
    [self.view addSubview:ctnt];
    [ctnt setContentSize:CGSizeMake(self.view.w, h+2)];
}

-(void)dochecked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSMutableDictionary *mt = [[indexs objectAtIndex:btn.tag] mutableCopy];
    [mt setValue:[NSNumber numberWithBool:btn.selected] forKey:@"IsMarked"];
    [indexs replaceObjectAtIndex:btn.tag withObject:mt];
    
    [btn setBackgroundColor:btn.selected ? [@"#ff4747" hexColor] : [UIColor clearColor]] ;
    if (btn.selected) {
        for (UIView *v in btn.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                break;
            }
        }
    }
}

- (void)emptyAction:(id)val { NSLog(@"%@",val);}

- (void)gotomain:(id)val{
    NSMutableString *outs = [NSMutableString string];
    for (NSDictionary *val in indexs) {
        if([val boolValueForKey:@"IsMarked"]){
            [outs appendFormat:@",%@",[val stringValueForKey:@"CategoryId"]];
        }
    }
    if (outs.length>0) {
         [VINet post:@"/api/categories/mark" args:@{@"CategoryIds":[outs substringFromIndex:1]} target:self succ:@selector(saveChange2Db:) error:@selector(showAlertError:) inv:self.view];
    }else{
        [self popTo:@"VINearByViewController"];
    }
}

- (void)saveChange2Db:(id)value
{
    [VIAlertView showInfoMsg:Lang(@"update_complte")];
    [self pop];
}

@end
