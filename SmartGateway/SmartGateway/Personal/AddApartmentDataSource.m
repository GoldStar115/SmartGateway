//
//  AddApartmentDataSource.m
//  SmartGateway
//
//  Created by Grace on 26/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "AddApartmentDataSource.h"
#import "AddApartmentCustomAutoCompleteObject.h"
//#import "Condo.h"

@implementation AddApartmentDataSource

#pragma mark - MLPAutoCompleteTextField DataSource


//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
        }
        
        NSMutableArray *completions = [[NSMutableArray alloc] init];
//        NSArray *completions;
//        if(self.testWithAutoCompleteObjectsInsteadOfStrings){
//            completions = [self allCountryObjects];
//        } else {
//            completions = [self allCountries];
//        }
        
        if(string.length >= 2)
        {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [[dm apiEngine] apartmentCondos:string
                               onCompletion:^(NSString *message, NSMutableArray *result) {
                                   [SVProgressHUD dismiss];
                                   for(Condo *condo in result)
                                   {
                                       AddApartmentCustomAutoCompleteObject *cObject = [[AddApartmentCustomAutoCompleteObject alloc] initWithCondo:condo];
                                       [completions addObject:cObject];
                                   }
                                   handler(completions);
                               }
                                    onError:^(NSError* error) {
                                        [SVProgressHUD dismiss];
//                                        [UIAlertView showWithError:error];
//                                        [self showError:error onCompletion:^(UIButton *sender) {
//                                            if(!condoArray)
//                                                [self popViewController];
//                                        }];
                                    }
         ];
        }
        else
            handler(completions);
    });
}

/*
 - (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
 {
 
 if(self.simulateLatency){
 CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
 NSLog(@"sleeping fetch of completions for %f", seconds);
 sleep(seconds);
 }
 
 NSArray *completions;
 if(self.testWithAutoCompleteObjectsInsteadOfStrings){
 completions = [self allCountryObjects];
 } else {
 completions = [self allCountries];
 }
 
 return completions;
 }
 */

/*- (NSArray *)allCountryObjects
{
    if(!self.countryObjects){
        NSArray *countryNames = [self allCountries];
        NSMutableArray *mutableCountries = [NSMutableArray new];
        for(NSString *countryName in countryNames){
            AddApartmentCustomAutoCompleteObject *country = [[AddApartmentCustomAutoCompleteObject alloc] initWithCountry:countryName];
            [mutableCountries addObject:country];
        }
        
        [self setCountryObjects:[NSArray arrayWithArray:mutableCountries]];
    }
    
    return self.countryObjects;
}


- (NSArray *)allCountries
{
    NSArray *countries =
    @[
      @"Abkhazia",
      @"Afghanistan",
      @"Aland",
      @"Albania",
      @"Algeria",
      @"American Samoa",
      @"Andorra",
      @"Angola",
      @"Anguilla",
      @"Antarctica",
      @"Antigua & Barbuda",
      @"Argentina",
      @"Armenia",
      @"Aruba",
      @"Australia",
      @"Austria",
      @"Azerbaijan",
      @"Bahamas",
      @"Bahrain",
      @"Bangladesh",
      @"Barbados",
      @"Belarus",
      @"Belgium",
      @"Belize",
      @"Benin",
      @"Bermuda",
      @"Bhutan",
      @"Bolivia",
      @"Bosnia & Herzegovina",
      @"Botswana",
      @"Brazil",
      @"British Antarctic Territory",
      @"British Virgin Islands",
      @"Brunei",
      @"Bulgaria",
      @"Burkina Faso",
      @"Burundi",
      @"Cambodia",
      @"Cameroon",
      @"Canada",
      @"Cape Verde",
      @"Cayman Islands",
      @"Central African Republic",
      @"Chad",
      @"Chile",
      @"China",
      @"Christmas Island",
      @"Cocos Keeling Islands",
      @"Colombia",
      @"Commonwealth",
      @"Comoros",
      @"Cook Islands",
      @"Costa Rica",
      @"Cote d'Ivoire",
      @"Croatia",
      @"Cuba",
      @"Cyprus",
      @"Czech Republic",
      @"Democratic Republic of the Congo",
      @"Denmark",
      @"Djibouti",
      @"Dominica",
      @"Dominican Republic",
      @"East Timor",
      @"Ecuador",
      @"Egypt",
      @"El Salvador",
      @"England",
      @"Equatorial Guinea",
      @"Eritrea",
      @"Estonia",
      @"Ethiopia",
      @"European Union",
      @"Falkland Islands",
      @"Faroes",
      @"Fiji",
      @"Finland",
      @"France",
      @"Gabon",
      @"Gambia",
      @"Georgia",
      @"Germany",
      @"Ghana",
      @"Gibraltar",
      @"GoSquared",
      @"Greece",
      @"Greenland",
      @"Grenada",
      @"Guam",
      @"Guatemala",
      @"Guernsey",
      @"Guinea Bissau",
      @"Guinea",
      @"Guyana",
      @"Haiti",
      @"Honduras",
      @"Hong Kong",
      @"Hungary",
      @"Iceland",
      @"India",
      @"Indonesia",
      @"Iran",
      @"Iraq",
      @"Ireland",
      @"Isle of Man",
      @"Israel",
      @"Italy",
      @"Jamaica",
      @"Japan",
      @"Jersey",
      @"Jordan",
      @"Kazakhstan",
      @"Kenya",
      @"Kiribati",
      @"Kosovo",
      @"Kuwait",
      @"Kyrgyzstan",
      @"Laos",
      @"Latvia",
      @"Lebanon",
      @"Lesotho",
      @"Liberia",
      @"Libya",
      @"Liechtenstein",
      @"Lithuania",
      @"Luxembourg",
      @"Macau",
      @"Macedonia",
      @"Madagascar",
      @"Malawi",
      @"Malaysia",
      @"Maldives",
      @"Mali",
      @"Malta",
      @"Mars",
      @"Marshall Islands",
      @"Mauritania",
      @"Mauritius",
      @"Mayotte",
      @"Mexico",
      @"Micronesia",
      @"Moldova",
      @"Monaco",
      @"Mongolia",
      @"Montenegro",
      @"Montserrat",
      @"Morocco",
      @"Mozambique",
      @"Myanmar",
      @"Nagorno Karabakh",
      @"Namibia",
      @"NATO",
      @"Nauru",
      @"Nepal",
      @"Netherlands Antilles",
      @"Netherlands",
      @"New Caledonia",
      @"New Zealand",
      @"Nicaragua",
      @"Niger",
      @"Nigeria",
      @"Niue",
      @"Norfolk Island",
      @"North Korea",
      @"Northern Cyprus",
      @"Northern Mariana Islands",
      @"Norway",
      @"Olympics",
      @"Oman",
      @"Pakistan",
      @"Palau",
      @"Palestine",
      @"Panama",
      @"Papua New Guinea",
      @"Paraguay",
      @"Peru",
      @"Philippines",
      @"Pitcairn Islands",
      @"Poland",
      @"Portugal",
      @"Puerto Rico",
      @"Qatar",
      @"Red Cross",
      @"Republic of the Congo",
      @"Romania",
      @"Russia",
      @"Rwanda",
      @"Saint Barthelemy",
      @"Saint Helena",
      @"Saint Kitts & Nevis",
      @"Saint Lucia",
      @"Saint Vincent & the Grenadines",
      @"Samoa",
      @"San Marino",
      @"Sao Tome & Principe",
      @"Saudi Arabia",
      @"Scotland",
      @"Senegal",
      @"Serbia",
      @"Seychelles",
      @"Sierra Leone",
      @"Singapore",
      @"Slovakia",
      @"Slovenia",
      @"Solomon Islands",
      @"Somalia",
      @"Somaliland",
      @"South Africa",
      @"South Georgia & the South Sandwich Islands",
      @"South Korea",
      @"South Ossetia",
      @"South Sudan",
      @"Spain",
      @"Sri Lanka",
      @"Sudan",
      @"Suriname",
      @"Swaziland",
      @"Sweden",
      @"Switzerland",
      @"Syria",
      @"Taiwan",
      @"Tajikistan",
      @"Tanzania",
      @"Thailand",
      @"Togo",
      @"Tonga",
      @"Trinidad & Tobago",
      @"Tunisia",
      @"Turkey",
      @"Turkmenistan",
      @"Turks & Caicos Islands",
      @"Tuvalu",
      @"Uganda",
      @"Ukraine",
      @"United Arab Emirates",
      @"United Kingdom",
      @"United Nations",
      @"United States",
      @"Uruguay",
      @"US Virgin Islands",
      @"Uzbekistan",
      @"Vanuatu",
      @"Vatican City",
      @"Venezuela",
      @"Vietnam",
      @"Wales",
      @"Western Sahara",
      @"Yemen",
      @"Zambia",
      @"Zimbabwe"
      ];
    
    return countries;
}
*/

@end
