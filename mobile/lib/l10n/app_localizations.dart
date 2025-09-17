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
  /// **'Analyze your health data with ChatGPT, Claude and more'**
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
  /// **'Simply ask questions about your health in everyday language'**
  String get chatgpt_feature_1;

  /// No description provided for @chatgpt_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Get instant, personalized insights about your wellness trends'**
  String get chatgpt_feature_2;

  /// No description provided for @chatgpt_feature_3.
  ///
  /// In en, this message translates to:
  /// **'No technical knowledge needed - just start a conversation'**
  String get chatgpt_feature_3;

  /// No description provided for @chatgpt_feature_4.
  ///
  /// In en, this message translates to:
  /// **'Understand your health data with clear, friendly explanations'**
  String get chatgpt_feature_4;

  /// No description provided for @chatgpt_integration_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT is one of the world\'s most popular AI assistants. With vytalLink\'s custom GPT, analyzing your health data becomes incredibly simple and intuitive.'**
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
  /// **'First, go to the Home screen and tap \'Start Connection\' to connect this app. You\'ll receive a connection word and PIN that you\'ll use to authenticate with ChatGPT.'**
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
  /// **'We\'ve created a special version of ChatGPT specifically designed for health data analysis. This custom GPT understands health metrics and can provide personalized insights about your wellness journey in simple, easy-to-understand language.'**
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
  /// **'These credentials are temporary and automatically generated by the backend each time you connect. They provide secure access without storing any sensitive information on your device. New credentials are created for every connection session to ensure maximum security.'**
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

  /// No description provided for @health_client_config_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to configure health client'**
  String get health_client_config_failed;

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
  /// **'We do not store or keep any of your health data. We simply act as an intermediary with the provider you choose. To connect to the server, you must first accept and grant permissions to access your health wearables. Only then can we send your data as you request.'**
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
  /// **'To connect and share your health data with AI assistants, you need to grant ALL the following permissions:\n\n• Access to health data (steps, heart rate, sleep, workouts)\n• Access to health history (more than 30 days)\n\nBoth permissions are mandatory for the connection to work.'**
  String get health_permissions_dialog_message;

  /// No description provided for @health_permissions_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Health Data Access Required'**
  String get health_permissions_dialog_title;

  /// No description provided for @home_button_start_server.
  ///
  /// In en, this message translates to:
  /// **'Start Connection'**
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

  /// No description provided for @home_description_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the vytalLink server. Please check your connection and try again.'**
  String get home_description_error;

  /// No description provided for @home_description_offline.
  ///
  /// In en, this message translates to:
  /// **'Ready to start the vytalLink server on this device'**
  String get home_description_offline;

  /// No description provided for @home_description_running.
  ///
  /// In en, this message translates to:
  /// **'vytalLink server is active and ready to receive connections'**
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

  /// Shows the endpoint
  ///
  /// In en, this message translates to:
  /// **'Endpoint: {endpoint}'**
  String home_endpoint_label(String endpoint);

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

  /// No description provided for @home_status_error.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get home_status_error;

  /// No description provided for @home_status_offline.
  ///
  /// In en, this message translates to:
  /// **'vytalLink Server Offline'**
  String get home_status_offline;

  /// No description provided for @home_status_running.
  ///
  /// In en, this message translates to:
  /// **'vytalLink Server Running'**
  String get home_status_running;

  /// No description provided for @home_status_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting Server...'**
  String get home_status_starting;

  /// No description provided for @home_status_stopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping Server...'**
  String get home_status_stopping;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'vytalLink Server Control'**
  String get home_title;

  /// No description provided for @how_it_works_step1_description.
  ///
  /// In en, this message translates to:
  /// **'Use the codes above to connect'**
  String get how_it_works_step1_description;

  /// No description provided for @how_it_works_step1_title.
  ///
  /// In en, this message translates to:
  /// **'Connect the server'**
  String get how_it_works_step1_title;

  /// No description provided for @how_it_works_step2_description.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT, Claude, or any compatible AI client'**
  String get how_it_works_step2_description;

  /// No description provided for @how_it_works_step2_title.
  ///
  /// In en, this message translates to:
  /// **'Configure your AI'**
  String get how_it_works_step2_title;

  /// No description provided for @how_it_works_step3_description.
  ///
  /// In en, this message translates to:
  /// **'Get personalized insights from your data'**
  String get how_it_works_step3_description;

  /// No description provided for @how_it_works_step3_title.
  ///
  /// In en, this message translates to:
  /// **'Ask about your health'**
  String get how_it_works_step3_title;

  /// No description provided for @how_it_works_title.
  ///
  /// In en, this message translates to:
  /// **'How It Works?'**
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

  /// No description provided for @mcp_choose_development_tool.
  ///
  /// In en, this message translates to:
  /// **'Choose your development tool'**
  String get mcp_choose_development_tool;

  /// No description provided for @mcp_claude_desktop_description.
  ///
  /// In en, this message translates to:
  /// **'Anthropic\'s desktop AI assistant. Ideal for general use, chat, and productivity.'**
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
  /// **'Direct integration with Claude Desktop and other MCP clients'**
  String get mcp_feature_1;

  /// No description provided for @mcp_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Secure and standardized data access protocol'**
  String get mcp_feature_2;

  /// No description provided for @mcp_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Professional-grade AI development tools'**
  String get mcp_feature_3;

  /// No description provided for @mcp_feature_4.
  ///
  /// In en, this message translates to:
  /// **'Real-time data synchronization'**
  String get mcp_feature_4;

  /// No description provided for @mcp_integration_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Claude, Cursor, VS Code and other professional AI development tools for advanced data analysis.'**
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
  /// **'View Setup Guide'**
  String get mcp_setup_guide_button;

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
  /// **'Install the vytalLink MCP server package on your computer using npm.'**
  String get mcp_step_1_description;

  /// No description provided for @mcp_step_1_title.
  ///
  /// In en, this message translates to:
  /// **'Install MCP Server'**
  String get mcp_step_1_title;

  /// No description provided for @mcp_step_2_description.
  ///
  /// In en, this message translates to:
  /// **'Add vytalLink to your Claude Desktop, Cursor, or VS Code MCP configuration.'**
  String get mcp_step_2_description;

  /// No description provided for @mcp_step_2_title.
  ///
  /// In en, this message translates to:
  /// **'Configure Your MCP Client'**
  String get mcp_step_2_title;

  /// No description provided for @mcp_step_3_description.
  ///
  /// In en, this message translates to:
  /// **'Start asking questions about your health data in your MCP client. When prompted, provide the connection word and PIN shown in this app. Once connected, you can analyze your health data directly within your professional AI tools.'**
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
  /// **'Model Context Protocol (MCP) is a standard that allows AI applications to securely access external data sources. It\'s used by professional tools like Claude Desktop, Cursor, and VS Code.'**
  String get mcp_what_is_description;

  /// No description provided for @mcp_what_is_title.
  ///
  /// In en, this message translates to:
  /// **'What is MCP?'**
  String get mcp_what_is_title;

  /// No description provided for @onboarding_ai_integration_description.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set! Start connecting your health data with AI assistants to get personalized insights and take control of your wellness journey.'**
  String get onboarding_ai_integration_description;

  /// No description provided for @onboarding_ai_integration_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Secure and private data sharing'**
  String get onboarding_ai_integration_feature_1;

  /// No description provided for @onboarding_ai_integration_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Instant setup with connection codes'**
  String get onboarding_ai_integration_feature_2;

  /// No description provided for @onboarding_ai_integration_feature_3.
  ///
  /// In en, this message translates to:
  /// **'24/7 AI health companion'**
  String get onboarding_ai_integration_feature_3;

  /// No description provided for @onboarding_ai_integration_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to explore your health with AI?'**
  String get onboarding_ai_integration_subtitle;

  /// No description provided for @onboarding_ai_integration_title.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_ai_integration_title;

  /// No description provided for @onboarding_ask_questions_description.
  ///
  /// In en, this message translates to:
  /// **'Simply ask questions about your health data in everyday language and get personalized insights.'**
  String get onboarding_ask_questions_description;

  /// No description provided for @onboarding_ask_questions_feature_1.
  ///
  /// In en, this message translates to:
  /// **'How has my sleep quality changed?'**
  String get onboarding_ask_questions_feature_1;

  /// No description provided for @onboarding_ask_questions_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Show my heart rate during workouts'**
  String get onboarding_ask_questions_feature_2;

  /// No description provided for @onboarding_ask_questions_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Graph my steps for the entire week'**
  String get onboarding_ask_questions_feature_3;

  /// No description provided for @onboarding_ask_questions_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get insights in natural language'**
  String get onboarding_ask_questions_subtitle;

  /// No description provided for @onboarding_ask_questions_title.
  ///
  /// In en, this message translates to:
  /// **'Ask Questions'**
  String get onboarding_ask_questions_title;

  /// No description provided for @onboarding_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_get_started;

  /// No description provided for @onboarding_health_monitoring_description.
  ///
  /// In en, this message translates to:
  /// **'Monitor your heart rate, steps, sleep patterns, and more with seamless integration to your favorite health apps.'**
  String get onboarding_health_monitoring_description;

  /// No description provided for @onboarding_health_monitoring_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Real-time heart rate monitoring'**
  String get onboarding_health_monitoring_feature_1;

  /// No description provided for @onboarding_health_monitoring_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Daily step and activity tracking'**
  String get onboarding_health_monitoring_feature_2;

  /// No description provided for @onboarding_health_monitoring_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Integration with Google Fit & Apple Health'**
  String get onboarding_health_monitoring_feature_3;

  /// No description provided for @onboarding_health_monitoring_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your vital signs in real-time'**
  String get onboarding_health_monitoring_subtitle;

  /// No description provided for @onboarding_health_monitoring_title.
  ///
  /// In en, this message translates to:
  /// **'Health Monitoring'**
  String get onboarding_health_monitoring_title;

  /// No description provided for @onboarding_how_it_works_description.
  ///
  /// In en, this message translates to:
  /// **'vytalLink seamlessly integrates with ChatGPT GPTs and MCP clients like Claude Desktop, Cursor, and VS Code.'**
  String get onboarding_how_it_works_description;

  /// No description provided for @onboarding_how_it_works_feature_1.
  ///
  /// In en, this message translates to:
  /// **'ChatGPT Custom GPTs integration'**
  String get onboarding_how_it_works_feature_1;

  /// No description provided for @onboarding_how_it_works_feature_2.
  ///
  /// In en, this message translates to:
  /// **'MCP server for Claude & professional tools'**
  String get onboarding_how_it_works_feature_2;

  /// No description provided for @onboarding_how_it_works_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Secure authentication with connection codes'**
  String get onboarding_how_it_works_feature_3;

  /// No description provided for @onboarding_how_it_works_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with your favorite AI tools'**
  String get onboarding_how_it_works_subtitle;

  /// No description provided for @onboarding_how_it_works_title.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
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
  /// **'Transform how you understand and manage your health with intelligent insights and comprehensive monitoring.'**
  String get onboarding_welcome_description;

  /// No description provided for @onboarding_welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal health companion powered by AI'**
  String get onboarding_welcome_subtitle;

  /// No description provided for @onboarding_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to vytalLink'**
  String get onboarding_welcome_title;
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
