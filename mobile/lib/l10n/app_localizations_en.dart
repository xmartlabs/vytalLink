// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ai_integration_chatgpt => 'ChatGPT';

  @override
  String get ai_integration_chatgpt_subtitle => 'Most Popular';

  @override
  String get ai_integration_mcp => 'MCP';

  @override
  String get ai_integration_mcp_subtitle => 'Claude, Cursor';

  @override
  String get ai_integration_subtitle =>
      'Ask ChatGPT, Claude, and other AI tools about your health data';

  @override
  String get ai_integration_title => 'Connect with AI';

  @override
  String get app_name => 'vytalLink';

  @override
  String get chatgpt_example_1 =>
      'What were my average heart rate and steps yesterday?';

  @override
  String get chatgpt_example_2 => 'Show me my sleep patterns for the last week';

  @override
  String get chatgpt_example_3 =>
      'How many calories did I burn during my last workout?';

  @override
  String get chatgpt_example_4 =>
      'Compare my activity levels between this month and last month';

  @override
  String get chatgpt_example_5 =>
      'What time did I go to bed on average this week?';

  @override
  String get chatgpt_example_6 =>
      'Show me my health trends over the past 30 days';

  @override
  String get chatgpt_examples_description =>
      'Here are some questions you can ask ChatGPT about your health data:';

  @override
  String get chatgpt_examples_title => 'Example Questions';

  @override
  String get chatgpt_feature_1 =>
      'Ask questions about your health like you\'d talk to a friend';

  @override
  String get chatgpt_feature_2 =>
      'Get quick answers about your sleep, workouts, and trends';

  @override
  String get chatgpt_feature_3 => 'No setup headaches - just start asking';

  @override
  String get chatgpt_feature_4 =>
      'Plain English explanations, no confusing charts';

  @override
  String get chatgpt_integration_hero_subtitle =>
      'ChatGPT already knows how to talk about health data. Our custom GPT makes it even easier to get answers about your sleep, workouts, and trends.';

  @override
  String get chatgpt_integration_hero_title => 'Connect with ChatGPT';

  @override
  String get chatgpt_integration_title => 'ChatGPT Integration';

  @override
  String get chatgpt_open_custom_gpt => 'Open vytalLink GPT';

  @override
  String get chatgpt_setup_title => 'How to Set Up';

  @override
  String get chatgpt_start_button => 'Start with ChatGPT';

  @override
  String get chatgpt_step_1_description =>
      'First, go to the Home screen and tap \'Get Word + PIN\' to connect this app. You\'ll receive a connection word and PIN that you\'ll use to authenticate with ChatGPT.';

  @override
  String get chatgpt_step_1_title => 'Connect This App';

  @override
  String get chatgpt_step_2_description =>
      'We recommend using ChatGPT on the web at chatgpt.com since this app needs to stay open to send your data to ChatGPT.';

  @override
  String get chatgpt_step_2_title => 'Open ChatGPT Web';

  @override
  String get chatgpt_step_3_description =>
      'In ChatGPT, go to GPTs and search for \'vytalLink\'. Click on it and then select \'Start Chat\' to begin.';

  @override
  String get chatgpt_step_3_title => 'Find vytalLink GPT';

  @override
  String get chatgpt_step_4_description =>
      'Ask any question about your health data. ChatGPT will request your connection word and PIN - simply provide the credentials shown in this app, then start exploring your health insights!';

  @override
  String get chatgpt_step_4_title => 'Connect and Start Asking';

  @override
  String get chatgpt_what_is_description =>
      'We built a custom GPT that knows how to read your health data. Ask it anything about your sleep, workouts, steps, or heart rate and get clear answers without the tech jargon.';

  @override
  String get chatgpt_what_is_title => 'What is vytalLink\'s Custom GPT?';

  @override
  String get connection_code_label => 'Connection Code';

  @override
  String connection_copied_to_clipboard(String label) {
    return '$label copied to clipboard';
  }

  @override
  String get connection_copy_button => 'Copy';

  @override
  String get connection_could_not_connect_default =>
      'Could not connect to server';

  @override
  String get connection_could_not_establish => 'Could not establish connection';

  @override
  String get connection_credentials_info_button => 'Info';

  @override
  String get connection_credentials_info_message =>
      'These credentials change every time you connect. They let your AI assistant access your data for this chat only - no personal info gets stored anywhere.';

  @override
  String get connection_credentials_info_title => 'About Temporary Credentials';

  @override
  String get connection_credentials_subtitle =>
      'These credentials are temporary and change with each connection';

  @override
  String get connection_credentials_title => 'Temporary Credentials';

  @override
  String get connection_error_network_description =>
      'Unable to connect to the vytalLink server. Please check your internet connection and try again.';

  @override
  String get connection_error_network_title => 'Connection Failed';

  @override
  String connection_error_prefix(String error) {
    return 'Connection error: $error';
  }

  @override
  String get connection_error_retry => 'Retry Connection';

  @override
  String get connection_error_server_description =>
      'The vytalLink server is not responding. Please verify the server is running and try again.';

  @override
  String get connection_error_server_title => 'Server Connection Error';

  @override
  String get connection_error_title => 'Connection Error';

  @override
  String get connection_failed_to_establish =>
      'Connection failed - could not establish';

  @override
  String get connection_lost_description =>
      'The connection to the vytalLink server was lost unexpectedly. Please check your network and try reconnecting.';

  @override
  String get connection_lost_title => 'Connection Lost';

  @override
  String get connection_lost_unexpectedly => 'Connection lost unexpectedly';

  @override
  String get connection_lost_with_server => 'Connection lost with server';

  @override
  String get connection_not_connected => 'Not connected to backend';

  @override
  String get connection_password_label => 'Connection Word';

  @override
  String get connection_retry_button => 'Retry';

  @override
  String get connection_section_title => 'Connection Credentials';

  @override
  String get copied_to_clipboard => 'Copied to clipboard';

  @override
  String get credentials_copied_to_clipboard =>
      'Credentials copied to clipboard';

  @override
  String get credentials_keep_app_open => 'Keep app open and device unlocked';

  @override
  String get credentials_pin_label => 'PIN';

  @override
  String get credentials_privacy_reminder =>
      'You choose what gets shared. Disconnect anytime to stop access.';

  @override
  String credentials_text(String word, String pin) {
    return 'Word: $word • PIN: $pin';
  }

  @override
  String get credentials_word_label => 'WORD';

  @override
  String error(String text) {
    return 'Error: $text';
  }

  @override
  String get error_button_ok => 'Ok';

  @override
  String get error_button_retry => 'Retry';

  @override
  String get error_no_internet_connection_error_description =>
      'You have no internet connection';

  @override
  String get error_no_internet_connection_error_title => 'Error';

  @override
  String get error_unknown_error_description => 'Something went wrong!';

  @override
  String get error_unknown_error_title => 'Ops!';

  @override
  String get example_config_title => 'Example Claude Configuration:';

  @override
  String get faq_empty_message => 'No FAQs available';

  @override
  String get faq_screen_subtitle =>
      'Answers about setup, privacy, supported platforms, and more';

  @override
  String get faq_screen_title => 'Frequently Asked Questions';

  @override
  String get health_client_config_failed => 'Failed to configure health client';

  @override
  String get health_connect_required_alert_cancel => 'Not now';

  @override
  String get health_connect_required_alert_install => 'Install';

  @override
  String get health_connect_required_alert_message =>
      'vytalLink uses Google Health Connect to securely sync your activity, sleep, and workout data from your Android device. Install Health Connect to enable the connection and keep your information flowing safely.';

  @override
  String get health_connect_required_alert_title =>
      'Install Google Health Connect';

  @override
  String get health_data_unavailable => 'Health data unavailable';

  @override
  String get health_permission_required => 'Health permission required';

  @override
  String get health_permissions_alert_accept => 'Accept';

  @override
  String get health_permissions_alert_cancel => 'Cancel';

  @override
  String get health_permissions_alert_message =>
      'We don\'t store your health data anywhere. This app just passes it along to your AI assistant when you ask questions. You\'ll need to allow access to your wearable data first.';

  @override
  String get health_permissions_alert_title => 'Health Data Privacy';

  @override
  String get health_permissions_dialog_accept => 'Allow';

  @override
  String get health_permissions_dialog_cancel => 'Cancel';

  @override
  String get health_permissions_dialog_message =>
      'To share your health data with AI assistants, you need to allow:\n\n• Access to health data (steps, heart rate, sleep, workouts)\n• Access to health history (more than 30 days)\n\nBoth are required for the app to work.';

  @override
  String get health_permissions_dialog_title => 'Health Data Access Required';

  @override
  String get home_banner_bridge_active =>
      'Connection Active — keep the app open while you chat.';

  @override
  String get home_button_chatgpt => 'Chat with ChatGPT';

  @override
  String get home_button_claude => 'Chat with Claude';

  @override
  String get home_button_start_server => 'Get Word + PIN';

  @override
  String get home_button_starting => 'Starting...';

  @override
  String get home_button_stop_server => 'Stop Connection';

  @override
  String get home_button_stopping => 'Stopping...';

  @override
  String get home_checklist_step_1 => 'Get your Word + PIN on this phone';

  @override
  String get home_checklist_step_2 =>
      'Open ChatGPT (search \"vytalLink\") or Claude on desktop';

  @override
  String get home_checklist_step_3 => 'Paste your Word + PIN and start asking';

  @override
  String get home_checklist_title => 'How it works';

  @override
  String get home_description_error =>
      'Unable to connect to the vytalLink server. Please check your connection and try again.';

  @override
  String get home_description_offline =>
      'Connect your AI assistant to get insights from your wearable data.';

  @override
  String get home_description_running =>
      'Open ChatGPT or Claude on your computer and paste your Word + PIN.';

  @override
  String get home_description_starting =>
      'Initializing vytalLink server and binding to port...';

  @override
  String get home_description_stopping =>
      'Shutting down server and closing connections...';

  @override
  String get home_dialog_chatgpt_body =>
      'You\'re all set! Open ChatGPT on your computer, find the vytalLink GPT, paste your Word + PIN, and start asking questions.';

  @override
  String get home_dialog_chatgpt_title => 'Chat with ChatGPT';

  @override
  String get home_dialog_chatgpt_view_guide => 'View ChatGPT instructions';

  @override
  String get home_dialog_claude_body =>
      'You\'re all set! Download the Claude Desktop bundle (or set up the npm server if you\'re technical), paste your Word + PIN, and start asking questions.';

  @override
  String get home_dialog_claude_title => 'Chat with Claude';

  @override
  String get home_dialog_claude_view_guide => 'View Claude instructions';

  @override
  String home_endpoint_label(String endpoint) {
    return 'Endpoint: $endpoint';
  }

  @override
  String get home_helper_chat_runs_elsewhere =>
      'You chat in ChatGPT or Claude; this app only shares what you approve.';

  @override
  String get home_helper_keep_open_reason =>
      'Close the app and your AI can\'t get new data.';

  @override
  String get home_link_faq => 'FAQ';

  @override
  String get home_link_where_do_i_chat => 'ChatGPT setup guide';

  @override
  String get home_note_keep_open => 'Keep the app open while you chat.';

  @override
  String get home_online_status => 'ONLINE';

  @override
  String home_server_ip_label(String ipAddress) {
    return 'Server IP: $ipAddress';
  }

  @override
  String get home_status_error => 'Connection Error';

  @override
  String get home_status_offline => 'Ready to Connect';

  @override
  String get home_status_running => 'Bridge Active';

  @override
  String get home_status_starting => 'Starting Connection...';

  @override
  String get home_status_stopping => 'Stopping Connection...';

  @override
  String get home_title => 'vytalLink';

  @override
  String get home_toast_copy_success => 'Copied to clipboard.';

  @override
  String get home_toast_credentials_ready =>
      'Word + PIN ready - paste it into your AI assistant.';

  @override
  String get home_value_prop_point_1 =>
      'Analyze your metrics in ChatGPT, Claude, or your MCP client';

  @override
  String get home_value_prop_point_2 =>
      'Generate a Word + PIN from this phone whenever you need it';

  @override
  String get home_value_prop_point_3 =>
      'Keep this app open while you chat so insights stay live';

  @override
  String get home_value_prop_subtitle =>
      'Ask ChatGPT or Claude questions about your health data without giving up your privacy—this app just keeps the connection alive.';

  @override
  String get home_value_prop_title => 'Ask your AI about your health data';

  @override
  String get how_it_works_step1_description =>
      'Tap \'Get Word + PIN\' to generate your credentials';

  @override
  String get how_it_works_step1_title => 'Generate your Word + PIN';

  @override
  String get how_it_works_step2_description =>
      'Open ChatGPT or Claude on the web or desktop';

  @override
  String get how_it_works_step2_title => 'Open your AI assistant';

  @override
  String get how_it_works_step3_description =>
      'Paste your Word + PIN and keep this app open for live insights';

  @override
  String get how_it_works_step3_title => 'Ask about your data';

  @override
  String get how_it_works_title => 'How it works';

  @override
  String get mcp_any_client_description =>
      'Any client that implements the MCP protocol is supported.';

  @override
  String get mcp_any_client_name => 'Any MCP Client';

  @override
  String get mcp_bundle_guide_button => 'Open Claude bundle guide';

  @override
  String get mcp_bundle_section_description =>
      'Double-click to install vytalLink in Claude Desktop. Works on Mac and Windows.';

  @override
  String get mcp_bundle_section_title => 'Claude Desktop Bundle (one-click)';

  @override
  String get mcp_choose_development_tool => 'Choose your development tool';

  @override
  String get mcp_claude_desktop_description =>
      'Claude\'s desktop app with one-click vytalLink setup.';

  @override
  String get mcp_claude_desktop_name => 'Claude Desktop';

  @override
  String get mcp_cursor_description => 'AI-powered code editor';

  @override
  String get mcp_cursor_name => 'Cursor';

  @override
  String get mcp_development_tools_description =>
      'Professional code editors with MCP support';

  @override
  String get mcp_development_tools_name => 'Development Tools';

  @override
  String get mcp_example_1 =>
      'Analyze health data directly in Claude Desktop conversations';

  @override
  String get mcp_example_2 =>
      'Access health metrics in your development workflow with Cursor';

  @override
  String get mcp_example_3 =>
      'Build health-focused applications with VS Code integration';

  @override
  String get mcp_example_4 => 'Create custom analysis and reporting tools';

  @override
  String get mcp_examples_description => 'With MCP integration, you can:';

  @override
  String get mcp_examples_title => 'What You Can Do';

  @override
  String get mcp_feature_1 =>
      'One-click Claude Desktop setup plus support for any MCP client';

  @override
  String get mcp_feature_2 =>
      'Secure connection between your phone and desktop AI tools';

  @override
  String get mcp_feature_3 => 'Works with professional AI development tools';

  @override
  String get mcp_feature_4 => 'Live data updates while you chat';

  @override
  String get mcp_integration_hero_subtitle =>
      'Install the Claude Desktop bundle or connect Cursor/VS Code to analyze your health data like a pro.';

  @override
  String get mcp_integration_hero_title => 'Connect with Professional AI Tools';

  @override
  String get mcp_integration_title => 'Professional AI Tools';

  @override
  String get mcp_recommended_badge => 'Recommended';

  @override
  String get mcp_setup_guide_button => 'Open advanced npm guide';

  @override
  String get mcp_setup_intro =>
      'This is for developers who want to use other MCP clients. Most people should use the Claude Desktop bundle above.';

  @override
  String get mcp_setup_nodejs_requirement =>
      'You must have Node.js installed on your system to run the vytalLink server.';

  @override
  String get mcp_setup_title => 'How to Set Up';

  @override
  String get mcp_start_button => 'Start with MCP';

  @override
  String get mcp_step_1_description =>
      'Pick your setup. Easy way: use the Claude Desktop bundle for one-click install. Developer way: run the npm command below.';

  @override
  String get mcp_step_1_title => 'Pick Your Install Path';

  @override
  String get mcp_step_2_description =>
      'If you used npm, add vytalLink to your MCP config in Claude Desktop, Cursor, or VS Code. The bundle handles Claude Desktop automatically.';

  @override
  String get mcp_step_2_title => 'Configure Your MCP Client';

  @override
  String get mcp_step_3_description =>
      'Start asking questions about your health data. When your AI asks for credentials, give it the Word + PIN from this app.';

  @override
  String get mcp_step_3_title => 'Connect and Start Analyzing';

  @override
  String get mcp_supported_clients_title => 'Supported Clients';

  @override
  String get mcp_vscode_description => 'With MCP extension support';

  @override
  String get mcp_vscode_name => 'VS Code';

  @override
  String get mcp_what_is_description =>
      'MCP is a way for AI tools to safely connect to your data. Professional apps like Claude Desktop, Cursor, and VS Code use it.';

  @override
  String get mcp_what_is_title => 'What is MCP?';

  @override
  String get onboarding_ai_integration_description =>
      'Tap \'Get Word + PIN\' to get your connection details. In <b>ChatGPT</b>, search for \'vytalLink\' and start chatting; or use the <b>Claude</b> bundle. <b>Keep the app open</b> while you chat. You control what gets shared and can disconnect anytime.';

  @override
  String get onboarding_ai_integration_feature_1 =>
      'Tap \'Get Word + PIN\' → Word + PIN';

  @override
  String get onboarding_ai_integration_feature_2 =>
      'Open ChatGPT or your MCP client';

  @override
  String get onboarding_ai_integration_feature_3 =>
      'Keep the app open; you control sharing';

  @override
  String get onboarding_ai_integration_subtitle =>
      'Next step: open your AI assistant';

  @override
  String get onboarding_ai_integration_title => 'Start Chatting Now';

  @override
  String get onboarding_ask_questions_description =>
      'Get clear answers about your health data: compare sleep and workouts, track steps and heart rate. Try asking:';

  @override
  String get onboarding_ask_questions_feature_1 =>
      'Analyze my sleep last month vs. the previous one. Any recommendations?';

  @override
  String get onboarding_ask_questions_feature_2 =>
      'Chart my heart rate over the last month and highlight trends.';

  @override
  String get onboarding_ask_questions_feature_3 =>
      'How did deep sleep change on strength days vs. cardio?';

  @override
  String get onboarding_ask_questions_subtitle => 'Compare what matters';

  @override
  String get onboarding_ask_questions_title => 'Ask About Your Trends';

  @override
  String get onboarding_get_started => 'Get Started';

  @override
  String get onboarding_health_monitoring_description =>
      'Your watch or fitness tracker syncs to your phone. VytalLink reads that data - sleep, workouts, steps, heart rate - and shares it with your AI assistant when you ask.';

  @override
  String get onboarding_health_monitoring_feature_1 =>
      'Works with mainstream wearables';

  @override
  String get onboarding_health_monitoring_feature_2 =>
      'Sleep, workouts, steps, heart rate';

  @override
  String get onboarding_health_monitoring_feature_3 =>
      'Advanced vitals when available';

  @override
  String get onboarding_health_monitoring_subtitle =>
      'Watches, rings, and trackers that sync to your phone';

  @override
  String get onboarding_health_monitoring_title => 'From Your Wearables';

  @override
  String get onboarding_how_it_works_description =>
      'Tap \'Get Word + PIN\' to get your connection details and choose what to share. You chat in your AI assistant (not in this app). <b>Keep the app open</b> while you chat.';

  @override
  String get onboarding_how_it_works_feature_1 =>
      'Start in ChatGPT (zero setup)';

  @override
  String get onboarding_how_it_works_feature_2 =>
      'Claude Desktop Bundle (MCPB)';

  @override
  String get onboarding_how_it_works_feature_3 =>
      'MCP setup (for developers) works with Claude, Cursor, VS Code';

  @override
  String get onboarding_how_it_works_subtitle =>
      'Start in ChatGPT; desktop via Claude Bundle or MCP';

  @override
  String get onboarding_how_it_works_title => 'Connect Once, Chat Anywhere';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_previous => 'Previous';

  @override
  String get onboarding_skip => 'Skip';

  @override
  String get onboarding_welcome_description =>
      'Connect your phone\'s health data once, then ask <b>ChatGPT</b> or <b>Claude</b> on your computer about your sleep, workouts, steps, and trends. Get clear answers in seconds.';

  @override
  String get onboarding_welcome_feature_1 =>
      'Quick answers, no confusing dashboards';

  @override
  String get onboarding_welcome_feature_2 =>
      'Compare sleep, workouts, and steps in seconds';

  @override
  String get onboarding_welcome_feature_3 => 'Connect in one step: Word + PIN';

  @override
  String get onboarding_welcome_subtitle =>
      'Ask your AI assistant, no dashboards';

  @override
  String get onboarding_welcome_title => 'Make Your Wearable Data Make Sense';

  @override
  String get support_about => 'About vytalLink';

  @override
  String get support_contact => 'Contact Support';

  @override
  String get support_privacy => 'Privacy Policy';

  @override
  String get support_terms => 'Terms of Service';
}
