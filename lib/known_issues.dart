//TODO KNOWN ISSUES/ERRORS
//adding new category and subcategory to settings
//navigating to account screen

// TODO LONG TERM GOALS
// TODO setting option for auto insert decimal
//TODO reoccurring expenses

//TODO MAYBE GOALS
//TODO give each person an emoji Icon option



//TODO GENERAL
//TODO recover password
//TODO don't show the currency on a log in the list if it is the default currency
//TODO find an api to get the currency exchange rate information
//TODO Settings are not being retrieved? JSON error?
//TODO add customer journey account and setting setup screen to set the currency, create your categories, and add your name
// name to the same log, this will allow two logs to have the same categories even at the ID level regardless of their log
//TODO method to change the photo
//TODO how to handle auto scroll on the account screen and login screen
//TODO update all entries where a subcategory is deleted to use the "other" subcategory
//TODO confirm change password tool works as I have it commented out at the moment
//TODO log order needs to be an individual thing, as multiple users with different logs will oder them differently
//TODO add calculator
//TODO start splash screen earlier?
//TODO move tag list creators from UI (tag picker) to actions and state
//button on tags to visualize stats for that tag, spent, average, etc
//add blank option to new log
//multi select delete, if selected, they turn red, will need to add multiSelect to entries state, add icons to the tabBar, and have a confirmation dialog
//modify setting categories to utilize 3 buttons, cancel, restore to factory, and save
//add anonymous sign in and create red banner asking the user to signup or risk losing their data
//TODO, give user option to change default payer on a log and from there the FAB button will chose that as default for EntrySetNewSelect, until then, it defaults to the user


//TODO VISUAL
//TODO appDialog needs an invisible icon on the trailing side if there is no trailing
//TODO selectable shadow color on logs
//TODO settings for month/day separator on the entries screen
//TODO make note that transfer funds do not show up in monthly totals
//TODO is there a better way to handle "Other" in entries tiles



//TODO WARNINGS AND TOASTS to build
//add validation to min/max filter

//TODO PERFORMANCE
//make entry list tiles the same size and trail off too many tags

//TODO GENERAL IMPORTANT *************************
//move to null safety

//TODO START HERE
//build build local repository for currency fetcher
//build json decoder to show currency information

//TODO make entry responsive to currencies - DO THIS NEXT, edit currency_formatters, formatted amount
//refactor entries to handle foreign currencies
//changing currency clears all entered values, include warning
//fix filter to handle multiple currencies






//TODO ASK BORIS
// is having methods in the models bad practice, should they be extracted to the action - if it can be in an action, move it there - Answer - Yes

//HELPFUL COMMANDS
//flutter pub run build_runner build
//flutter packages pub run build_runner build --delete-conflicting-import 'package:qr_flutter/qr_flutter.dart';

//Conflicting outputs issue
// flutter clean
// flutter pub get
// flutter packages pub run build_runner build --delete-conflicting-import 'package:flutter/foundatioimport 'package:expenses/store/actions/single_entry_actions.import 'package:flutter/cupertino.dart';


