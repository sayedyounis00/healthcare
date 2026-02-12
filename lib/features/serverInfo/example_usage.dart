// Example: How to navigate to the Server Info page
//
// From anywhere in your app, you can navigate to the server info page like this:

import 'package:flutter/material.dart';
import 'package:healthcare/core/routing/routes.dart';

// Example 1: Navigate with a specific server URL
void navigateToServerInfo(BuildContext context, String serverUrl) {
  Navigator.pushNamed(
    context,
    Routes.serverInfo,
    arguments: serverUrl, // e.g., 'http://192.168.1.100:8080'
  );
}

// Example 2: Navigate with default URL (if you don't pass arguments)
void navigateToServerInfoDefault(BuildContext context) {
  Navigator.pushNamed(
    context,
    Routes.serverInfo,
    // No arguments - will use default: 'http://192.168.1.100:8080'
  );
}

// Example 3: In a button
class ExampleButton extends StatelessWidget {
  const ExampleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Replace with your actual server IP and port
        Navigator.pushNamed(
          context,
          Routes.serverInfo,
          arguments: 'http://192.168.1.5:8080', // Your Flask server URL
        );
      },
      child: const Text('Check Server Info'),
    );
  }
}

// Example 4: From a ListTile
class ServerInfoTile extends StatelessWidget {
  final String serverUrl;

  const ServerInfoTile({super.key, required this.serverUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dns),
      title: const Text('Server Information'),
      subtitle: Text(serverUrl),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.pushNamed(context, Routes.serverInfo, arguments: serverUrl);
      },
    );
  }
}
