import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Elivatme/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = 'English';
  bool _isDataManagementEnabled = true;
  bool _isPrivacyEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                    // Toggle dark mode
                    if (_isDarkMode) {
                      // Activate dark mode
                      // Example: ThemeController.setDarkMode(true);
                      // You can implement logic here to switch between light and dark themes
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
                        statusBarColor: Colors.transparent,
                      ));
                    } else {
                      // Activate light mode
                      // Example: ThemeController.setDarkMode(false);
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
                        statusBarColor: Colors.transparent,
                      ));
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ListTile(
              title: const Text(
                'Enable Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _isNotificationsEnabled = value;
                    // Toggle notification settings
                    // Example: NotificationController.setNotificationsEnabled(value);
                  });
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ListTile(
              title: const Text(
                'Change Language',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_selectedLanguage),
              onTap: () {
                // Navigate to language selection page
                _showLanguageSelectionDialog(context);
              },
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ListTile(
              title: const Text(
                'Enable Data Management',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: _isDataManagementEnabled,
                onChanged: (value) {
                  setState(() {
                    _isDataManagementEnabled = value;
                    // Toggle data management settings
                    // Example: DataManager.setDataManagementEnabled(value);
                  });
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ListTile(
              title: const Text(
                'Enable Privacy Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: _isPrivacyEnabled,
                onChanged: (value) {
                  setState(() {
                    _isPrivacyEnabled = value;
                    // Toggle privacy settings
                    // Example: PrivacyManager.setPrivacyEnabled(value);
                  });
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              'Version',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              '1.0.0', // Replace with the actual version number
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              '© 2024 SkyWay', 
              
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show language selection dialog
  Future<void> _showLanguageSelectionDialog(BuildContext context) async {
    final languages = ['English', 'Spanish', 'French']; // Example languages
    final selectedLanguage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: languages.map((String language) {
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    Navigator.pop(context, language);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (selectedLanguage != null) {
      setState(() {
        _selectedLanguage = selectedLanguage;
        // Update language settings
        // Example: LanguageManager.setLanguage(selectedLanguage);
      });
    }
  }
}
