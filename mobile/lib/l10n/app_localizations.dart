import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @ai_integration_chatgpt.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT'**
  String get ai_integration_chatgpt;

  /// No description provided for @ai_integration_chatgpt_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get ai_integration_chatgpt_subtitle;

  /// No description provided for @ai_integration_mcp.
  ///
  /// In en, this message translates to:
  /// **'MCP'**
  String get ai_integration_mcp;

  /// No description provided for @ai_integration_mcp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Claude, Cursor'**
  String get ai_integration_mcp_subtitle;

  /// No description provided for @ai_integration_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask ChatGPT, Claude, and other AI tools about your health data'**
  String get ai_integration_subtitle;

  /// No description provided for @ai_integration_title.
  ///
  /// In en, this message translates to:
  /// **'Connect with AI'**
  String get ai_integration_title;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'vytalLink'**
  String get app_name;

  /// No description provided for @chatgpt_example_1.
  ///
  /// In en, this message translates to:
  /// **'What were my average heart rate and steps yesterday?'**
  String get chatgpt_example_1;

  /// No description provided for @chatgpt_example_2.
  ///
  /// In en, this message translates to:
  /// **'Show me my sleep patterns for the last week'**
  String get chatgpt_example_2;

  /// No description provided for @chatgpt_example_3.
  ///
  /// In en, this message translates to:
  /// **'How many calories did I burn during my last workout?'**
  String get chatgpt_example_3;

  /// No description provided for @chatgpt_example_4.
  ///
  /// In en, this message translates to:
  /// **'Compare my activity levels between this month and last month'**
  String get chatgpt_example_4;

  /// No description provided for @chatgpt_example_5.
  ///
  /// In en, this message translates to:
  /// **'What time did I go to bed on average this week?'**
  String get chatgpt_example_5;

  /// No description provided for @chatgpt_example_6.
  ///
  /// In en, this message translates to:
  /// **'Show me my health trends over the past 30 days'**
  String get chatgpt_example_6;

  /// No description provided for @chatgpt_examples_description.
  ///
  /// In en, this message translates to:
  /// **'Here are some questions you can ask ChatGPT about your health data:'**
  String get chatgpt_examples_description;

  /// No description provided for @chatgpt_examples_title.
  ///
  /// In en, this message translates to:
  /// **'Example Questions'**
  String get chatgpt_examples_title;

  /// No description provided for @chatgpt_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Ask questions about your health like you\'d talk to a friend'**
  String get chatgpt_feature_1;

  /// No description provided for @chatgpt_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Get quick answers about your sleep, workouts, and trends'**
  String get chatgpt_feature_2;

  /// No description provided for @chatgpt_feature_3.
  ///
  /// In en, this message translates to:
  /// **'No setup headaches - just start asking'**
  String get chatgpt_feature_3;

  /// No description provided for @chatgpt_feature_4.
  ///
  /// In en, this message translates to:
  /// **'Plain English explanations, no confusing charts'**
  String get chatgpt_feature_4;

  /// No description provided for @chatgpt_helper_chat_runs_on_desktop.
  ///
  /// In en, this message translates to:
  /// **'<b>Chat right here or in ChatGPT on your computer.</b> This app keeps the bridge open and only shares what you approve.'**
  String get chatgpt_helper_chat_runs_on_desktop;

  /// No description provided for @chatgpt_integration_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT already knows how to talk about health data. Our custom GPT makes it even easier to get answers about your sleep, workouts, and trends.'**
  String get chatgpt_integration_hero_subtitle;

  /// No description provided for @chatgpt_integration_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Connect with ChatGPT'**
  String get chatgpt_integration_hero_title;

  /// No description provided for @chatgpt_integration_title.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT Integration'**
  String get chatgpt_integration_title;

  /// No description provided for @chatgpt_open_custom_gpt.
  ///
  /// In en, this message translates to:
  /// **'Open vytalLink GPT'**
  String get chatgpt_open_custom_gpt;

  /// No description provided for @chatgpt_setup_title.
  ///
  /// In en, this message translates to:
  /// **'How to Set Up'**
  String get chatgpt_setup_title;

  /// No description provided for @chatgpt_start_button.
  ///
  /// In en, this message translates to:
  /// **'Start with ChatGPT'**
  String get chatgpt_start_button;

  /// No description provided for @chatgpt_step_1_description.
  ///
  /// In en, this message translates to:
  /// **'First, go to the Home screen and tap \'Get Word + PIN\' to connect this app. You\'ll receive a connection word and PIN that you\'ll use to authenticate with ChatGPT.'**
  String get chatgpt_step_1_description;

  /// No description provided for @chatgpt_step_1_title.
  ///
  /// In en, this message translates to:
  /// **'Connect This App'**
  String get chatgpt_step_1_title;

  /// No description provided for @chatgpt_step_2_description.
  ///
  /// In en, this message translates to:
  /// **'We recommend using ChatGPT on the web at chatgpt.com since this app needs to stay open to send your data to ChatGPT.'**
  String get chatgpt_step_2_description;

  /// No description provided for @chatgpt_step_2_title.
  ///
  /// In en, this message translates to:
  /// **'Open ChatGPT Web'**
  String get chatgpt_step_2_title;

  /// No description provided for @chatgpt_step_3_description.
  ///
  /// In en, this message translates to:
  /// **'In ChatGPT, go to GPTs and search for \'vytalLink\'. Click on it and then select \'Start Chat\' to begin.'**
  String get chatgpt_step_3_description;

  /// No description provided for @chatgpt_step_3_title.
  ///
  /// In en, this message translates to:
  /// **'Find vytalLink GPT'**
  String get chatgpt_step_3_title;

  /// No description provided for @chatgpt_step_4_description.
  ///
  /// In en, this message translates to:
  /// **'Ask any question about your health data. ChatGPT will request your connection word and PIN - simply provide the credentials shown in this app, then start exploring your health insights!'**
  String get chatgpt_step_4_description;

  /// No description provided for @chatgpt_step_4_title.
  ///
  /// In en, this message translates to:
  /// **'Connect and Start Asking'**
  String get chatgpt_step_4_title;

  /// No description provided for @chatgpt_what_is_description.
  ///
  /// In en, this message translates to:
  /// **'We built a custom GPT that knows how to read your health data. Ask it anything about your sleep, workouts, steps, or heart rate and get clear answers without the tech jargon.'**
  String get chatgpt_what_is_description;

  /// No description provided for @chatgpt_what_is_title.
  ///
  /// In en, this message translates to:
  /// **'What is vytalLink\'s Custom GPT?'**
  String get chatgpt_what_is_title;

  /// No description provided for @connection_code_label.
  ///
  /// In en, this message translates to:
  /// **'Connection Code'**
  String get connection_code_label;

  /// Message shown when credential is copied
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard'**
  String connection_copied_to_clipboard(String label);

  /// No description provided for @connection_copy_button.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get connection_copy_button;

  /// No description provided for @connection_could_not_connect_default.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to server'**
  String get connection_could_not_connect_default;

  /// No description provided for @connection_could_not_establish.
  ///
  /// In en, this message translates to:
  /// **'Could not establish connection'**
  String get connection_could_not_establish;

  /// No description provided for @connection_credentials_info_button.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get connection_credentials_info_button;

  /// No description provided for @connection_credentials_info_message.
  ///
  /// In en, this message translates to:
  /// **'These credentials change every time you connect. They let your AI assistant access your data for this chat only - no personal info gets stored anywhere.'**
  String get connection_credentials_info_message;

  /// No description provided for @connection_credentials_info_title.
  ///
  /// In en, this message translates to:
  /// **'About Temporary Credentials'**
  String get connection_credentials_info_title;

  /// No description provided for @connection_credentials_subtitle.
  ///
  /// In en, this message translates to:
  /// **'These credentials are temporary and change with each connection'**
  String get connection_credentials_subtitle;

  /// No description provided for @connection_credentials_title.
  ///
  /// In en, this message translates to:
  /// **'Temporary Credentials'**
  String get connection_credentials_title;

  /// No description provided for @connection_error_network_description.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the vytalLink server. Please check your internet connection and try again.'**
  String get connection_error_network_description;

  /// No description provided for @connection_error_network_title.
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get connection_error_network_title;

  /// Connection error with details
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connection_error_prefix(String error);

  /// No description provided for @connection_error_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get connection_error_retry;

  /// No description provided for @connection_error_server_description.
  ///
  /// In en, this message translates to:
  /// **'The vytalLink server is not responding. Please verify the server is running and try again.'**
  String get connection_error_server_description;

  /// No description provided for @connection_error_server_title.
  ///
  /// In en, this message translates to:
  /// **'Server Connection Error'**
  String get connection_error_server_title;

  /// No description provided for @connection_error_title.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connection_error_title;

  /// No description provided for @connection_failed_to_establish.
  ///
  /// In en, this message translates to:
  /// **'Connection failed - could not establish'**
  String get connection_failed_to_establish;

  /// No description provided for @connection_lost_description.
  ///
  /// In en, this message translates to:
  /// **'The connection to the vytalLink server was lost unexpectedly. Please check your network and try reconnecting.'**
  String get connection_lost_description;

  /// No description provided for @connection_lost_title.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connection_lost_title;

  /// No description provided for @connection_lost_unexpectedly.
  ///
  /// In en, this message translates to:
  /// **'Connection lost unexpectedly'**
  String get connection_lost_unexpectedly;

  /// No description provided for @connection_lost_with_server.
  ///
  /// In en, this message translates to:
  /// **'Connection lost with server'**
  String get connection_lost_with_server;

  /// No description provided for @connection_not_connected.
  ///
  /// In en, this message translates to:
  /// **'Not connected to backend'**
  String get connection_not_connected;

  /// No description provided for @connection_password_label.
  ///
  /// In en, this message translates to:
  /// **'Connection Word'**
  String get connection_password_label;

  /// No description provided for @connection_retry_button.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get connection_retry_button;

  /// No description provided for @connection_section_title.
  ///
  /// In en, this message translates to:
  /// **'Connection Credentials'**
  String get connection_section_title;

  /// No description provided for @copied_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied_to_clipboard;

  /// No description provided for @credentials_copied_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Credentials copied to clipboard'**
  String get credentials_copied_to_clipboard;

  /// No description provided for @credentials_keep_app_open.
  ///
  /// In en, this message translates to:
  /// **'Keep app open and device unlocked'**
  String get credentials_keep_app_open;

  /// No description provided for @credentials_pin_label.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get credentials_pin_label;

  /// No description provided for @credentials_privacy_reminder.
  ///
  /// In en, this message translates to:
  /// **'You choose what gets shared. Disconnect anytime to stop access.'**
  String get credentials_privacy_reminder;

  /// Displays the connection word and PIN
  ///
  /// In en, this message translates to:
  /// **'Word: {word} • PIN: {pin}'**
  String credentials_text(String word, String pin);

  /// No description provided for @credentials_word_label.
  ///
  /// In en, this message translates to:
  /// **'WORD'**
  String get credentials_word_label;

  /// Gives the user an error explanation
  ///
  /// In en, this message translates to:
  /// **'Error: {text}'**
  String error(String text);

  /// No description provided for @error_button_ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get error_button_ok;

  /// No description provided for @error_button_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get error_button_retry;

  /// No description provided for @error_no_internet_connection_error_description.
  ///
  /// In en, this message translates to:
  /// **'You have no internet connection'**
  String get error_no_internet_connection_error_description;

  /// No description provided for @error_no_internet_connection_error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_no_internet_connection_error_title;

  /// No description provided for @error_unknown_error_description.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get error_unknown_error_description;

  /// No description provided for @error_unknown_error_title.
  ///
  /// In en, this message translates to:
  /// **'Ops!'**
  String get error_unknown_error_title;

  /// No description provided for @example_config_title.
  ///
  /// In en, this message translates to:
  /// **'Example Claude Configuration:'**
  String get example_config_title;

  /// No description provided for @faq_empty_message.
  ///
  /// In en, this message translates to:
  /// **'No FAQs available'**
  String get faq_empty_message;

  /// No description provided for @faq_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Answers about setup, privacy, supported platforms, and more'**
  String get faq_screen_subtitle;

  /// No description provided for @faq_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq_screen_title;

  /// No description provided for @health_client_config_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to configure health client'**
  String get health_client_config_failed;

  /// No description provided for @health_connect_required_alert_cancel.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get health_connect_required_alert_cancel;

  /// No description provided for @health_connect_required_alert_install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get health_connect_required_alert_install;

  /// No description provided for @health_connect_required_alert_message.
  ///
  /// In en, this message translates to:
  /// **'vytalLink uses Google Health Connect to securely sync your activity, sleep, and workout data from your Android device. Install Health Connect to enable the connection and keep your information flowing safely.'**
  String get health_connect_required_alert_message;

  /// No description provided for @health_connect_required_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Install Google Health Connect'**
  String get health_connect_required_alert_title;

  /// No description provided for @health_data_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Health data unavailable'**
  String get health_data_unavailable;

  /// No description provided for @health_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Health permission required'**
  String get health_permission_required;

  /// No description provided for @health_permissions_alert_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get health_permissions_alert_accept;

  /// No description provided for @health_permissions_alert_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get health_permissions_alert_cancel;

  /// No description provided for @health_permissions_alert_message.
  ///
  /// In en, this message translates to:
  /// **'We don\'t store your health data anywhere. This app just passes it along to your AI assistant when you ask questions. You\'ll need to allow access to your wearable data first.'**
  String get health_permissions_alert_message;

  /// No description provided for @health_permissions_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Health Data Privacy'**
  String get health_permissions_alert_title;

  /// No description provided for @health_permissions_dialog_accept.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get health_permissions_dialog_accept;

  /// No description provided for @health_permissions_dialog_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get health_permissions_dialog_cancel;

  /// No description provided for @health_permissions_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'To share your health data with AI assistants, you need to allow:\n\n• Access to health data (steps, heart rate, sleep, workouts)\n• Access to health history (more than 30 days)\n\nBoth are required for the app to work.'**
  String get health_permissions_dialog_message;

  /// No description provided for @health_permissions_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Health Data Access Required'**
  String get health_permissions_dialog_title;

  /// No description provided for @home_ai_card_blog_claude.
  ///
  /// In en, this message translates to:
  /// **'If you want something a little more powerful, Claude Desktop is an excellent choice. It often generates fantastic visualizations and better explanations.'**
  String get home_ai_card_blog_claude;

  /// No description provided for @home_ai_card_blog_gpt.
  ///
  /// In en, this message translates to:
  /// **'For most people, we suggest starting with the VytalLink GPT. You don\'t have to install anything; you get an assistant ready to go right away.'**
  String get home_ai_card_blog_gpt;

  /// No description provided for @home_ai_card_desktop_description.
  ///
  /// In en, this message translates to:
  /// **'Our recommended path: open ChatGPT.com, Claude Desktop, or another MCP client with your Word + PIN for the smoothest experience with more room, plugins, and pro workflows.'**
  String get home_ai_card_desktop_description;

  /// No description provided for @home_ai_card_desktop_hint.
  ///
  /// In en, this message translates to:
  /// **'Best experience for charts, longer sessions, and pro tools.'**
  String get home_ai_card_desktop_hint;

  /// No description provided for @home_ai_card_desktop_title.
  ///
  /// In en, this message translates to:
  /// **'Use GPT on desktop'**
  String get home_ai_card_desktop_title;

  /// No description provided for @home_ai_card_guide_header.
  ///
  /// In en, this message translates to:
  /// **'This guide walks you through both paths:'**
  String get home_ai_card_guide_header;

  /// No description provided for @home_ai_card_intro.
  ///
  /// In en, this message translates to:
  /// **'Your Word + PIN work anywhere; choose the flow that fits how you want to chat.'**
  String get home_ai_card_intro;

  /// No description provided for @home_ai_card_mobile_description.
  ///
  /// In en, this message translates to:
  /// **'Open the VytalLink GPT right here in the app so you can start chatting in seconds.'**
  String get home_ai_card_mobile_description;

  /// No description provided for @home_ai_card_mobile_hint.
  ///
  /// In en, this message translates to:
  /// **'Ideal for quick follow-ups when you only have your phone.'**
  String get home_ai_card_mobile_hint;

  /// No description provided for @home_ai_card_mobile_title.
  ///
  /// In en, this message translates to:
  /// **'Use GPT on this phone'**
  String get home_ai_card_mobile_title;

  /// No description provided for @home_banner_bridge_active.
  ///
  /// In en, this message translates to:
  /// **'Connection active'**
  String get home_banner_bridge_active;

  /// No description provided for @home_button_start_chat.
  ///
  /// In en, this message translates to:
  /// **'Start chatting'**
  String get home_button_start_chat;

  /// No description provided for @home_button_start_server.
  ///
  /// In en, this message translates to:
  /// **'Get Word + PIN'**
  String get home_button_start_server;

  /// No description provided for @home_button_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get home_button_starting;

  /// No description provided for @home_button_stop_server.
  ///
  /// In en, this message translates to:
  /// **'Stop Connection'**
  String get home_button_stop_server;

  /// No description provided for @home_button_stopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping...'**
  String get home_button_stopping;

  /// No description provided for @home_chatgpt_quick_actions_description.
  ///
  /// In en, this message translates to:
  /// **'Pick how you want to open the vytalLink GPT.'**
  String get home_chatgpt_quick_actions_description;

  /// No description provided for @home_chatgpt_quick_actions_in_app_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Keep this screen open and use the web to chat.'**
  String get home_chatgpt_quick_actions_in_app_unavailable;

  /// No description provided for @home_chatgpt_quick_actions_open_in_app.
  ///
  /// In en, this message translates to:
  /// **'Open in app'**
  String get home_chatgpt_quick_actions_open_in_app;

  /// No description provided for @home_chatgpt_quick_actions_open_in_browser.
  ///
  /// In en, this message translates to:
  /// **'Open on web'**
  String get home_chatgpt_quick_actions_open_in_browser;

  /// No description provided for @home_chatgpt_quick_actions_title.
  ///
  /// In en, this message translates to:
  /// **'Start chatting with ChatGPT'**
  String get home_chatgpt_quick_actions_title;

  /// No description provided for @home_chatgpt_quick_actions_view_instructions.
  ///
  /// In en, this message translates to:
  /// **'View desktop instructions'**
  String get home_chatgpt_quick_actions_view_instructions;

  /// No description provided for @home_checklist_step_1.
  ///
  /// In en, this message translates to:
  /// **'Get your Word + PIN on this phone'**
  String get home_checklist_step_1;

  /// No description provided for @home_checklist_step_2.
  ///
  /// In en, this message translates to:
  /// **'Open ChatGPT (search \"vytalLink\") here or on your computer.'**
  String get home_checklist_step_2;

  /// No description provided for @home_checklist_step_3.
  ///
  /// In en, this message translates to:
  /// **'Paste your Word + PIN and start asking'**
  String get home_checklist_step_3;

  /// No description provided for @home_checklist_title.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get home_checklist_title;

  /// Format used when copying Word and PIN to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'VytalLink credential — Word: {word} | PIN: {pin}'**
  String home_clipboard_credentials_template(String word, String pin);

  /// No description provided for @home_description_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the vytalLink server. Please check your connection and try again.'**
  String get home_description_error;

  /// No description provided for @home_description_offline.
  ///
  /// In en, this message translates to:
  /// **'Connect your AI assistant to get insights from your wearable data.'**
  String get home_description_offline;

  /// No description provided for @home_description_running.
  ///
  /// In en, this message translates to:
  /// **'Open ChatGPT on this phone or your computer, then paste your Word + PIN.'**
  String get home_description_running;

  /// No description provided for @home_description_starting.
  ///
  /// In en, this message translates to:
  /// **'Initializing vytalLink server and binding to port...'**
  String get home_description_starting;

  /// No description provided for @home_description_stopping.
  ///
  /// In en, this message translates to:
  /// **'Shutting down server and closing connections...'**
  String get home_description_stopping;

  /// No description provided for @home_dialog_chatgpt_desktop_bullet.
  ///
  /// In en, this message translates to:
  /// **'<b>Open on desktop</b>. Gives you more room, richer visuals, and the <b>smoothest experience</b> when you\'re at a computer.'**
  String get home_dialog_chatgpt_desktop_bullet;

  /// No description provided for @home_dialog_chatgpt_desktop_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Use ChatGPT.com, Claude Desktop, or any MCP client when you want the richest experience with more room and plugins.'**
  String get home_dialog_chatgpt_desktop_subtitle;

  /// No description provided for @home_dialog_chatgpt_desktop_title.
  ///
  /// In en, this message translates to:
  /// **'Open on desktop'**
  String get home_dialog_chatgpt_desktop_title;

  /// No description provided for @home_dialog_chatgpt_intro.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to start chatting:'**
  String get home_dialog_chatgpt_intro;

  /// No description provided for @home_dialog_chatgpt_mobile_bullet.
  ///
  /// In en, this message translates to:
  /// **'<b>Open ChatGPT on this phone</b>. Fast and simple when you\'re on the go, perfect for quick chats.'**
  String get home_dialog_chatgpt_mobile_bullet;

  /// No description provided for @home_dialog_chatgpt_mobile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Launches the VytalLink GPT in Safari View Controller or Chrome Custom Tab so you never leave the app.'**
  String get home_dialog_chatgpt_mobile_subtitle;

  /// No description provided for @home_dialog_chatgpt_mobile_title.
  ///
  /// In en, this message translates to:
  /// **'Open ChatGPT here'**
  String get home_dialog_chatgpt_mobile_title;

  /// No description provided for @home_dialog_chatgpt_view_guide.
  ///
  /// In en, this message translates to:
  /// **'View ChatGPT instructions'**
  String get home_dialog_chatgpt_view_guide;

  /// No description provided for @home_dialog_claude_view_guide.
  ///
  /// In en, this message translates to:
  /// **'View Claude instructions'**
  String get home_dialog_claude_view_guide;

  /// No description provided for @home_dialog_start_chat_body.
  ///
  /// In en, this message translates to:
  /// **'vytalLink is ready. Keep your Word + PIN handy and you\'re good to go.'**
  String get home_dialog_start_chat_body;

  /// No description provided for @home_dialog_start_chat_title.
  ///
  /// In en, this message translates to:
  /// **'Bridge ready - pick your flow'**
  String get home_dialog_start_chat_title;

  /// Shows the endpoint
  ///
  /// In en, this message translates to:
  /// **'Endpoint: {endpoint}'**
  String home_endpoint_label(String endpoint);

  /// No description provided for @home_helper_chat_runs_elsewhere.
  ///
  /// In en, this message translates to:
  /// **'You chat in ChatGPT or Claude; this app only shares what you approve.'**
  String get home_helper_chat_runs_elsewhere;

  /// No description provided for @home_helper_keep_open_reason.
  ///
  /// In en, this message translates to:
  /// **'Close or minimize the app and your AI can\'t get new data.'**
  String get home_helper_keep_open_reason;

  /// No description provided for @home_link_faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get home_link_faq;

  /// No description provided for @home_link_where_do_i_chat.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT setup guide'**
  String get home_link_where_do_i_chat;

  /// No description provided for @home_note_keep_open.
  ///
  /// In en, this message translates to:
  /// **'Keep the app open while you chat.'**
  String get home_note_keep_open;

  /// Notification body shown when the app auto-connects and credentials are ready.
  ///
  /// In en, this message translates to:
  /// **'Word: {word} | PIN: {pin}'**
  String home_notification_credentials_body(String word, String pin);

  /// No description provided for @home_notification_credentials_title.
  ///
  /// In en, this message translates to:
  /// **'Bridge activated'**
  String get home_notification_credentials_title;

  /// No description provided for @home_on_device_guidance_acknowledge.
  ///
  /// In en, this message translates to:
  /// **'Yep, I read the reminders.'**
  String get home_on_device_guidance_acknowledge;

  /// No description provided for @home_on_device_guidance_bullet_browser.
  ///
  /// In en, this message translates to:
  /// **'We\'ll open ChatGPT inside this app. <b>Stick with that in-app browser</b> so the bridge keeps flowing.'**
  String get home_on_device_guidance_bullet_browser;

  /// No description provided for @home_on_device_guidance_bullet_clipboard.
  ///
  /// In en, this message translates to:
  /// **'<b>Your Word + PIN are already copied.</b> Paste them when ChatGPT asks and you\'re in.'**
  String get home_on_device_guidance_bullet_clipboard;

  /// No description provided for @home_on_device_guidance_bullet_keyboard.
  ///
  /// In en, this message translates to:
  /// **'If the chat bar sits on top of our buttons on iOS, <b>scroll up a notch</b> and the keyboard shows up again. ChatGPT is working on a fix.'**
  String get home_on_device_guidance_bullet_keyboard;

  /// No description provided for @home_on_device_guidance_bullet_no_external_app.
  ///
  /// In en, this message translates to:
  /// **'<b>Skip any prompts to open or install the ChatGPT app.</b> Sending vytalLink to the background stops the data stream.'**
  String get home_on_device_guidance_bullet_no_external_app;

  /// No description provided for @home_on_device_guidance_intro.
  ///
  /// In en, this message translates to:
  /// **'This on-device chat is <b>great for quick questions</b> while you stay on your phone. If you want more space or plugins later, switch to your computer. Let\'s cover a few reminders first:'**
  String get home_on_device_guidance_intro;

  /// No description provided for @home_on_device_guidance_primary.
  ///
  /// In en, this message translates to:
  /// **'Open ChatGPT here'**
  String get home_on_device_guidance_primary;

  /// No description provided for @home_on_device_guidance_secondary.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get home_on_device_guidance_secondary;

  /// No description provided for @home_on_device_guidance_skip_checkbox.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show this screen again.'**
  String get home_on_device_guidance_skip_checkbox;

  /// No description provided for @home_on_device_guidance_title.
  ///
  /// In en, this message translates to:
  /// **'Before you open ChatGPT here'**
  String get home_on_device_guidance_title;

  /// No description provided for @home_online_status.
  ///
  /// In en, this message translates to:
  /// **'ONLINE'**
  String get home_online_status;

  /// Shows the server IP address
  ///
  /// In en, this message translates to:
  /// **'Server IP: {ipAddress}'**
  String home_server_ip_label(String ipAddress);

  /// No description provided for @home_snackbar_credentials_copied.
  ///
  /// In en, this message translates to:
  /// **'Word + PIN copied to your clipboard.'**
  String get home_snackbar_credentials_copied;

  /// No description provided for @home_status_error.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get home_status_error;

  /// No description provided for @home_status_offline.
  ///
  /// In en, this message translates to:
  /// **'Grab your Word + PIN to get started'**
  String get home_status_offline;

  /// No description provided for @home_status_running.
  ///
  /// In en, this message translates to:
  /// **'Bridge Active'**
  String get home_status_running;

  /// No description provided for @home_status_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting Connection...'**
  String get home_status_starting;

  /// No description provided for @home_status_stopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping Connection...'**
  String get home_status_stopping;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'vytalLink'**
  String get home_title;

  /// No description provided for @home_toast_copy_success.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard.'**
  String get home_toast_copy_success;

  /// No description provided for @home_toast_credentials_copied.
  ///
  /// In en, this message translates to:
  /// **'We copied your Word + PIN so you can paste them into ChatGPT.'**
  String get home_toast_credentials_copied;

  /// No description provided for @home_toast_credentials_missing.
  ///
  /// In en, this message translates to:
  /// **'Start the bridge first—your Word + PIN only appear when the app is connected.'**
  String get home_toast_credentials_missing;

  /// No description provided for @home_toast_credentials_ready.
  ///
  /// In en, this message translates to:
  /// **'Word + PIN ready - paste it into your AI assistant.'**
  String get home_toast_credentials_ready;

  /// No description provided for @home_value_prop_point_1.
  ///
  /// In en, this message translates to:
  /// **'Ask your metrics <b>on any screen</b> through ChatGPT, Claude, or your MCP client'**
  String get home_value_prop_point_1;

  /// No description provided for @home_value_prop_point_2.
  ///
  /// In en, this message translates to:
  /// **'<b>Generate a Word + PIN</b> from this phone whenever you need it'**
  String get home_value_prop_point_2;

  /// No description provided for @home_value_prop_point_3.
  ///
  /// In en, this message translates to:
  /// **'<b>Keep this app open</b> while you chat so insights stay live'**
  String get home_value_prop_point_3;

  /// No description provided for @home_value_prop_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask ChatGPT or Claude questions about your health data without giving up your privacy. This app just keeps the connection alive.'**
  String get home_value_prop_subtitle;

  /// No description provided for @home_value_prop_title.
  ///
  /// In en, this message translates to:
  /// **'Chat with your wearable data wherever you are'**
  String get home_value_prop_title;

  /// No description provided for @how_it_works_step1_description.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Get Word + PIN\' to generate your credentials'**
  String get how_it_works_step1_description;

  /// No description provided for @how_it_works_step1_title.
  ///
  /// In en, this message translates to:
  /// **'Generate your Word + PIN'**
  String get how_it_works_step1_title;

  /// No description provided for @how_it_works_step2_description.
  ///
  /// In en, this message translates to:
  /// **'Open ChatGPT here or on your computer and paste your Word + PIN'**
  String get how_it_works_step2_description;

  /// No description provided for @how_it_works_step2_title.
  ///
  /// In en, this message translates to:
  /// **'Open your AI assistant'**
  String get how_it_works_step2_title;

  /// No description provided for @how_it_works_step3_description.
  ///
  /// In en, this message translates to:
  /// **'Start asking about your data. Keep this app open for live insights'**
  String get how_it_works_step3_description;

  /// No description provided for @how_it_works_step3_title.
  ///
  /// In en, this message translates to:
  /// **'Ask about your data'**
  String get how_it_works_step3_title;

  /// No description provided for @how_it_works_title.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get how_it_works_title;

  /// No description provided for @mcp_any_client_description.
  ///
  /// In en, this message translates to:
  /// **'Any client that implements the MCP protocol is supported.'**
  String get mcp_any_client_description;

  /// No description provided for @mcp_any_client_name.
  ///
  /// In en, this message translates to:
  /// **'Any MCP Client'**
  String get mcp_any_client_name;

  /// No description provided for @mcp_bundle_guide_button.
  ///
  /// In en, this message translates to:
  /// **'Open Claude bundle guide'**
  String get mcp_bundle_guide_button;

  /// No description provided for @mcp_bundle_section_description.
  ///
  /// In en, this message translates to:
  /// **'Double-click to install vytalLink in Claude Desktop. Works on Mac and Windows.'**
  String get mcp_bundle_section_description;

  /// No description provided for @mcp_bundle_section_title.
  ///
  /// In en, this message translates to:
  /// **'Claude Desktop Bundle (one-click)'**
  String get mcp_bundle_section_title;

  /// No description provided for @mcp_choose_development_tool.
  ///
  /// In en, this message translates to:
  /// **'Choose your development tool'**
  String get mcp_choose_development_tool;

  /// No description provided for @mcp_claude_desktop_description.
  ///
  /// In en, this message translates to:
  /// **'Claude\'s desktop app with one-click vytalLink setup.'**
  String get mcp_claude_desktop_description;

  /// No description provided for @mcp_claude_desktop_name.
  ///
  /// In en, this message translates to:
  /// **'Claude Desktop'**
  String get mcp_claude_desktop_name;

  /// No description provided for @mcp_cursor_description.
  ///
  /// In en, this message translates to:
  /// **'AI-powered code editor'**
  String get mcp_cursor_description;

  /// No description provided for @mcp_cursor_name.
  ///
  /// In en, this message translates to:
  /// **'Cursor'**
  String get mcp_cursor_name;

  /// No description provided for @mcp_development_tools_description.
  ///
  /// In en, this message translates to:
  /// **'Professional code editors with MCP support'**
  String get mcp_development_tools_description;

  /// No description provided for @mcp_development_tools_name.
  ///
  /// In en, this message translates to:
  /// **'Development Tools'**
  String get mcp_development_tools_name;

  /// No description provided for @mcp_example_1.
  ///
  /// In en, this message translates to:
  /// **'Analyze health data directly in Claude Desktop conversations'**
  String get mcp_example_1;

  /// No description provided for @mcp_example_2.
  ///
  /// In en, this message translates to:
  /// **'Access health metrics in your development workflow with Cursor'**
  String get mcp_example_2;

  /// No description provided for @mcp_example_3.
  ///
  /// In en, this message translates to:
  /// **'Build health-focused applications with VS Code integration'**
  String get mcp_example_3;

  /// No description provided for @mcp_example_4.
  ///
  /// In en, this message translates to:
  /// **'Create custom analysis and reporting tools'**
  String get mcp_example_4;

  /// No description provided for @mcp_examples_description.
  ///
  /// In en, this message translates to:
  /// **'With MCP integration, you can:'**
  String get mcp_examples_description;

  /// No description provided for @mcp_examples_title.
  ///
  /// In en, this message translates to:
  /// **'What You Can Do'**
  String get mcp_examples_title;

  /// No description provided for @mcp_feature_1.
  ///
  /// In en, this message translates to:
  /// **'One-click Claude Desktop setup plus support for any MCP client'**
  String get mcp_feature_1;

  /// No description provided for @mcp_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Secure connection between your phone and advanced AI tools'**
  String get mcp_feature_2;

  /// No description provided for @mcp_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Works with professional AI development tools'**
  String get mcp_feature_3;

  /// No description provided for @mcp_feature_4.
  ///
  /// In en, this message translates to:
  /// **'Live data updates while you chat'**
  String get mcp_feature_4;

  /// No description provided for @mcp_foreground_channel_description.
  ///
  /// In en, this message translates to:
  /// **'Keeps your phone linked to AI helpers while the app stays in the background'**
  String get mcp_foreground_channel_description;

  /// No description provided for @mcp_foreground_channel_name.
  ///
  /// In en, this message translates to:
  /// **'Health data bridge'**
  String get mcp_foreground_channel_name;

  /// No description provided for @mcp_foreground_notification_text.
  ///
  /// In en, this message translates to:
  /// **'Share word “{word}” and PIN “{code}” to connect'**
  String mcp_foreground_notification_text(String word, String code);

  /// No description provided for @mcp_foreground_notification_title.
  ///
  /// In en, this message translates to:
  /// **'Connected to your AI'**
  String get mcp_foreground_notification_title;

  /// No description provided for @mcp_foreground_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get mcp_foreground_status_pending;

  /// No description provided for @mcp_foreground_notification_button_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mcp_foreground_notification_button_close;

  /// No description provided for @mcp_helper_chat_runs_on_desktop.
  ///
  /// In en, this message translates to:
  /// **'<b>Chats happen in your AI client</b> such as ChatGPT, Claude Desktop, Cursor, or VS Code. This app keeps the bridge open and only shares what you approve.'**
  String get mcp_helper_chat_runs_on_desktop;

  /// No description provided for @mcp_integration_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Install the Claude Desktop bundle or connect Cursor/VS Code to analyze your health data like a pro.'**
  String get mcp_integration_hero_subtitle;

  /// No description provided for @mcp_integration_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Connect with Professional AI Tools'**
  String get mcp_integration_hero_title;

  /// No description provided for @mcp_integration_title.
  ///
  /// In en, this message translates to:
  /// **'Professional AI Tools'**
  String get mcp_integration_title;

  /// No description provided for @mcp_recommended_badge.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get mcp_recommended_badge;

  /// No description provided for @mcp_setup_guide_button.
  ///
  /// In en, this message translates to:
  /// **'Open advanced npm guide'**
  String get mcp_setup_guide_button;

  /// No description provided for @mcp_setup_intro.
  ///
  /// In en, this message translates to:
  /// **'This is for developers who want to use other MCP clients. Most people should use the Claude Desktop bundle above.'**
  String get mcp_setup_intro;

  /// Requirement message shown in setup step 1, clarifying that Node.js must be installed.
  ///
  /// In en, this message translates to:
  /// **'You must have Node.js installed on your system to run the vytalLink server.'**
  String get mcp_setup_nodejs_requirement;

  /// No description provided for @mcp_setup_title.
  ///
  /// In en, this message translates to:
  /// **'How to Set Up'**
  String get mcp_setup_title;

  /// No description provided for @mcp_start_button.
  ///
  /// In en, this message translates to:
  /// **'Start with MCP'**
  String get mcp_start_button;

  /// No description provided for @mcp_step_1_description.
  ///
  /// In en, this message translates to:
  /// **'Pick your setup. Easy way: use the Claude Desktop bundle for one-click install. Developer way: run the npm command below.'**
  String get mcp_step_1_description;

  /// No description provided for @mcp_step_1_title.
  ///
  /// In en, this message translates to:
  /// **'Pick Your Install Path'**
  String get mcp_step_1_title;

  /// No description provided for @mcp_step_2_description.
  ///
  /// In en, this message translates to:
  /// **'If you used npm, add vytalLink to your MCP config in Claude Desktop, Cursor, or VS Code. The bundle handles Claude Desktop automatically.'**
  String get mcp_step_2_description;

  /// No description provided for @mcp_step_2_title.
  ///
  /// In en, this message translates to:
  /// **'Configure Your MCP Client'**
  String get mcp_step_2_title;

  /// No description provided for @mcp_step_3_description.
  ///
  /// In en, this message translates to:
  /// **'Start asking questions about your health data. When your AI asks for credentials, give it the Word + PIN from this app.'**
  String get mcp_step_3_description;

  /// No description provided for @mcp_step_3_title.
  ///
  /// In en, this message translates to:
  /// **'Connect and Start Analyzing'**
  String get mcp_step_3_title;

  /// No description provided for @mcp_supported_clients_title.
  ///
  /// In en, this message translates to:
  /// **'Supported Clients'**
  String get mcp_supported_clients_title;

  /// No description provided for @mcp_vscode_description.
  ///
  /// In en, this message translates to:
  /// **'With MCP extension support'**
  String get mcp_vscode_description;

  /// No description provided for @mcp_vscode_name.
  ///
  /// In en, this message translates to:
  /// **'VS Code'**
  String get mcp_vscode_name;

  /// No description provided for @mcp_what_is_description.
  ///
  /// In en, this message translates to:
  /// **'MCP is a way for AI tools to safely connect to your data. Professional apps like Claude Desktop, Cursor, and VS Code use it.'**
  String get mcp_what_is_description;

  /// No description provided for @mcp_what_is_title.
  ///
  /// In en, this message translates to:
  /// **'What is MCP?'**
  String get mcp_what_is_title;

  /// No description provided for @onboarding_ai_integration_description.
  ///
  /// In en, this message translates to:
  /// **'Tap <b>Get Word + PIN</b> before you start, open ChatGPT here or on your computer, paste the codes, keep the app running, and stay in control of what’s shared.'**
  String get onboarding_ai_integration_description;

  /// No description provided for @onboarding_ai_integration_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Word + PIN is unique every session'**
  String get onboarding_ai_integration_feature_1;

  /// No description provided for @onboarding_ai_integration_feature_2.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT, Claude, or any MCP client is ready'**
  String get onboarding_ai_integration_feature_2;

  /// No description provided for @onboarding_ai_integration_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Keep the app open to share, close it to stop'**
  String get onboarding_ai_integration_feature_3;

  /// No description provided for @onboarding_ai_integration_subtitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get onboarding_ai_integration_subtitle;

  /// No description provided for @onboarding_ai_integration_title.
  ///
  /// In en, this message translates to:
  /// **'Start Chatting Now'**
  String get onboarding_ai_integration_title;

  /// No description provided for @onboarding_ask_questions_description.
  ///
  /// In en, this message translates to:
  /// **'Ask about your habits, surface the patterns, and turn them into next steps. Try questions like these.'**
  String get onboarding_ask_questions_description;

  /// No description provided for @onboarding_ask_questions_feature_1.
  ///
  /// In en, this message translates to:
  /// **'\"How did my sleep change last month compared with the one before?\"'**
  String get onboarding_ask_questions_feature_1;

  /// No description provided for @onboarding_ask_questions_feature_2.
  ///
  /// In en, this message translates to:
  /// **'\"Chart my heart rate for the past month and call out any trends.\"'**
  String get onboarding_ask_questions_feature_2;

  /// No description provided for @onboarding_ask_questions_feature_3.
  ///
  /// In en, this message translates to:
  /// **'\"What happened to deep sleep on strength days versus cardio days?\"'**
  String get onboarding_ask_questions_feature_3;

  /// No description provided for @onboarding_ask_questions_subtitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get onboarding_ask_questions_subtitle;

  /// No description provided for @onboarding_ask_questions_title.
  ///
  /// In en, this message translates to:
  /// **'Ask About Your Trends'**
  String get onboarding_ask_questions_title;

  /// No description provided for @onboarding_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_get_started;

  /// No description provided for @onboarding_health_monitoring_description.
  ///
  /// In en, this message translates to:
  /// **'When your watch, ring, or tracker syncs to your phone, vytalLink pulls that data (sleep, workouts, steps, heart rate) into your chat whenever you ask.'**
  String get onboarding_health_monitoring_description;

  /// No description provided for @onboarding_health_monitoring_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Works with the wearables you already use'**
  String get onboarding_health_monitoring_feature_1;

  /// No description provided for @onboarding_health_monitoring_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Sleep, workouts, steps, and heart rate arrive together'**
  String get onboarding_health_monitoring_feature_2;

  /// No description provided for @onboarding_health_monitoring_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Advanced vitals flow through when your device supports them'**
  String get onboarding_health_monitoring_feature_3;

  /// No description provided for @onboarding_health_monitoring_subtitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get onboarding_health_monitoring_subtitle;

  /// No description provided for @onboarding_health_monitoring_title.
  ///
  /// In en, this message translates to:
  /// **'Your Wearable Data, Ready for Chat'**
  String get onboarding_health_monitoring_title;

  /// No description provided for @onboarding_how_it_works_description.
  ///
  /// In en, this message translates to:
  /// **'Open vytalLink, tap <b>Get Word + PIN</b>, paste those codes when your AI asks, and keep the app open while you chat. Close it whenever you want to stop sharing.'**
  String get onboarding_how_it_works_description;

  /// No description provided for @onboarding_how_it_works_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Fast start in ChatGPT with zero setup'**
  String get onboarding_how_it_works_feature_1;

  /// No description provided for @onboarding_how_it_works_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Claude Desktop bundle handles the computer setup'**
  String get onboarding_how_it_works_feature_2;

  /// No description provided for @onboarding_how_it_works_feature_3.
  ///
  /// In en, this message translates to:
  /// **'MCP setup covers Claude, Cursor, and VS Code'**
  String get onboarding_how_it_works_feature_3;

  /// No description provided for @onboarding_how_it_works_subtitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get onboarding_how_it_works_subtitle;

  /// No description provided for @onboarding_how_it_works_title.
  ///
  /// In en, this message translates to:
  /// **'Connect Once, Chat Anywhere'**
  String get onboarding_how_it_works_title;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get onboarding_previous;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @onboarding_welcome_description.
  ///
  /// In en, this message translates to:
  /// **'Link your phone’s health data once and let <b>ChatGPT</b> or <b>Claude</b> answer questions about your sleep, workouts, steps, and trends. No dashboards, just clear answers.'**
  String get onboarding_welcome_description;

  /// No description provided for @onboarding_welcome_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Quick answers without dashboards'**
  String get onboarding_welcome_feature_1;

  /// No description provided for @onboarding_welcome_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Compare sleep, workouts, and steps in seconds'**
  String get onboarding_welcome_feature_2;

  /// No description provided for @onboarding_welcome_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Connect in one step with Word + PIN'**
  String get onboarding_welcome_feature_3;

  /// No description provided for @onboarding_welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get onboarding_welcome_subtitle;

  /// No description provided for @onboarding_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Make Your Wearable Data Make Sense'**
  String get onboarding_welcome_title;

  /// No description provided for @support_about.
  ///
  /// In en, this message translates to:
  /// **'About vytalLink'**
  String get support_about;

  /// No description provided for @support_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get support_contact;

  /// No description provided for @support_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get support_privacy;

  /// No description provided for @support_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get support_terms;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
