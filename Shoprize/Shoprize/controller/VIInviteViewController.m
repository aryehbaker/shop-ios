//
//  VIInviteViewController.m
//  ShopriseComm
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIInviteViewController.h"
@import AddressBook;
@import MessageUI;
#import "CMPopTipView.h"
#import "KUtils.h"

@interface VIInviteViewController ()<MFMessageComposeViewControllerDelegate>
{
    UITableView *listTable;
    BOOL isAllChecked;
}
@property(nonatomic,strong) NSMutableArray *contacts;
@property(nonatomic,strong) NSMutableArray *all_contacts;
@end

@implementation VIInviteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contacts = [NSMutableArray array];
    self.all_contacts = [NSMutableArray array];
    isAllChecked = NO;
    
    [self findContacts];
    
    [self addCommentPage:.6];
    [self setLightContent];
    [self addNav:@"@search_w.png" left:BACK right:MENU];
    UIView *action = [self loadXib:@"UI.xib" withTag:8000];
    [action label4Tag:8001].text = Lang(@"shoose_all");
    [action label4Tag:8001].font = Bold(19);
    [[action button4Tag:8002] setTitle:Lang(@"ck_all") selected:Lang(@"ck_all")];
    [[action button4Tag:8002] addTarget:self action:@selector(checkAll:)];
    [[action button4Tag:8002] titleLabel].font = Regular(14);
    [action setY:self.nav.endY];
    [self.view addSubview:action];
    
    listTable = [[UITableView alloc] initWithFrame:Frm(0, action.endY, 320, Space(action.endY)-40) style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:listTable];
    
    UIButton *inVIen = [[UIButton alloc] initWithFrame:Frm(-1, self.view.h - 39, 322, 40)];
    inVIen.backgroundColor = [@"#ff4747" hexColor];
    [inVIen setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal ];
    [inVIen setTitle:Lang(@"invite_now") selected:Lang(@"invite_now")];
    inVIen.titleLabel.font = Bold(20);
    [inVIen addTarget:self action:@selector(sendMessage:)];
    [self.view addSubview:inVIen];
}

- (void)doCenterIconClick:(UITapGestureRecognizer *)evt
{
    int X = evt.view.frame.origin.x;
    
    if (X<100) {
        [self showSearchFiled:nil];
        [UIView animateWithDuration:.28 animations:^{
            [self.view viewWithTag:-10010].x = 10;
            evt.view.x = (320 - evt.view.w)/2;
        } completion:^(BOOL finished) {
           
        }];
        
    }else{
        [UIView animateWithDuration:.28 animations:^{
            [self.view viewWithTag:-10010].x = -50;
            evt.view.x = 10;
        } completion:^(BOOL finished) {
            if (finished) {
                [self showSearchFiled:nil];
            }
        }];
    }
    
}

- (void)checkAll:(UIButton *)sender
{
    NSString *check = isAllChecked ? @"NO" : @"YES";
    for (int index=0;index<self.contacts.count;index++) {
        NSMutableDictionary *dict = [[self contacts] objectAtIndex:index];
        [dict setValue:check forKey:@"checked"];
        [self.contacts replaceObjectAtIndex:index withObject:dict];
    }
    isAllChecked = !isAllChecked;
    [sender setTitle:!isAllChecked ? Lang(@"ck_all") : Lang(@"ck_none") selected:isAllChecked ? Lang(@"ck_all") : Lang(@"ck_none") ];
    
    [listTable reloadData];
}

- (void)sendMessage:(id)sender
{
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
    if(!canSendSMS){
        [VIAlertView showErrorMsg:Lang(@"deveice_not_suppor")];
        return;
    }
    NSMutableArray *cts = [NSMutableArray array];
    for (int index=0;index<self.contacts.count;index++) {
        NSMutableDictionary *dict = [[self contacts] objectAtIndex:index];
        if ([[dict stringValueForKey:@"checked"] isEqualToString:@"YES"]) {
            [cts addObject:[dict stringValueForKey:@"phone"]];
        }
    }
    if (cts.count == 0) {
        [VIAlertView showErrorMsg:Lang(@"should_check_one")];
        return;
    }
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.body = Lang(@"invint_sms_txt");
    picker.recipients = cts;
    
    [self presentModalViewController:picker];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    if (result == MessageComposeResultSent) {
        [VIAlertView showErrorMsg:Lang(@"send_sms_complete")];
    }
    
    if (result == MessageComposeResultFailed) {
         [VIAlertView showErrorMsg:Lang(@"send_sms_fail")];
    }
    
    [self dismissModalViewController];
}

- (void)findContacts{
    [[self contacts] removeAllObjects];
    [[self all_contacts] removeAllObjects];
    
    ABAddressBookRef tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    if (tmpAddressBook==nil) {
        return ;
    };
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples)
    {
       NSString* FirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
       NSString* LastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
       ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
       long phos = ABMultiValueGetCount(tmpPhones);
       if (phos==0) { continue;}
       NSString *phoneNum = nil;
      for(long j2 = 0; j2 < phos; j2++)
       {
           phoneNum = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j2);
           break;
       }
       
        NSMutableDictionary *dict = [ NSMutableDictionary dictionary];
        [dict setValue:Fmt(@"%@%@",FirstName == nil ? @"" : FirstName ,LastName == nil ? @"" : LastName) forKey:@"name"];
        [dict setValue:phoneNum forKey:@"phone"];
        [dict setValue:@"NO" forKey:@"checked"];
        [self.contacts addObject:dict];
    }
    [listTable reloadData];
    [self.all_contacts addObjectsFromArray:self.contacts];
}

- (void)whenSearchKey:(NSString *)search
{
    [self.contacts removeAllObjects];
    if (search!=nil && ![search isEqualToString:@""]) {
        for (NSDictionary *d in self.all_contacts) {
            if (
                [[d stringValueForKey:@"name" defaultValue:@""] like:search]
                ||[[d stringValueForKey:@"phone" defaultValue:@""] like:search]
                ) {
                [self.contacts addObject:d];
            }
        }
        [listTable reloadData];
        return;
    }
    [self.contacts addObjectsFromArray:self.all_contacts];
    [listTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellviewId = Fmt(@"list_cell_id_col%ld_row%ld",(long)indexPath.section,(long)indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellviewId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellviewId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *data = [self.contacts objectAtIndex:indexPath.row];
    
    [cell.contentView removeSubviews];
    
    UIView *line = [[UIView alloc] initWithFrame:Frm(51,0, 194, 1)];
    line.backgroundColor = [@"#AEB1B4" hexColor];
    [cell.contentView addSubview:line];
    UILabel *rtlable = [UILabel initWithFrame:Frm(51, 0, 194, 44) color:@"#ffffff" font:FontS(20) align:RIGHT];
    rtlable.text = [data stringValueForKey:@"name"];
    [cell.contentView addSubview:rtlable];
    UIButton *checked = [UIButton buttonWithType:UIButtonTypeCustom];
    checked.tag = indexPath.row;
    checked.selected = [[data stringValueForKey:@"checked"] isEqualToString:@"YES"];
    [checked addTarget:self action:@selector(doCheck:)];
    checked.frame = Frm(rtlable.endX+7, 2, 40, 40);
    checked.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10);
    [checked setImage:[@"inv_add.png" image] forState:UIControlStateNormal];
    [checked setImage:[@"iv_del.png" image] forState:UIControlStateSelected];
    [cell.contentView addSubview:checked];
    
    return cell;
}

- (void)doCheck:(UIButton *)btn
{
    NSMutableDictionary *dict = [self.contacts objectAtIndex:btn.tag];
    [dict setValue:[[dict stringValueForKey:@"checked"] isEqualToString:@"YES"] ? @"NO" : @"YES" forKey:@"checked"];
    [self.contacts replaceObjectAtIndex:btn.tag withObject:dict];
    [listTable reloadData];
}

@end
