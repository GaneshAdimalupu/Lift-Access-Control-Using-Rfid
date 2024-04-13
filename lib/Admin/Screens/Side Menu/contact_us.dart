import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors
              .white, // Set a background color to avoid transparency affecting the entire UI
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 200, // Adjusted to 180
                width: 200, // Adjusted to 180
                child: Image.asset(
                  'assets/images/logo_light.png',
                  color:
                      Colors.white.withOpacity(0.2), // Adjust transparency here
                  colorBlendMode: BlendMode.dstATop,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send us a message',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ContactForm(),
                  SizedBox(height: 40),
                  Text(
                    'Or contact us directly:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ContactDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 160.0), // Adjust vertical padding

            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
            onSaved: (value) {
              _message = value!;
            },
          ),
          SizedBox(height: 24),
          SizedBox(
              child: Center(
                  child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _sendEmail();
                }
              },
              child: Align(
                // Align the text within the button
                alignment: Alignment.center,

                child: Text('Send'),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            ),
          )))
        ],
      ),
    );
  }

  Future<void> _sendEmail() async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ganeshjohn253@gmail.com',
      queryParameters: {
        'subject': 'Message from Elivatme Contact Form',
        'body': _message
      },
    );
    await launch(_emailLaunchUri.toString());
  }
}

class ContactDetails extends StatelessWidget {
  const ContactDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.email),
          title: Text(
            'Email: ganeshjohn253@gmail.com',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            final Uri _emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'ganeshjohn253@gmail.com',
            );
            await launch(_emailLaunchUri.toString());
          },
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(
            'Phone: 6303205936',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            final Uri _phoneLaunchUri = Uri(
              scheme: 'tel',
              path: '+916303205936',
            );
            await launch(_phoneLaunchUri.toString());
          },
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text(
            'WhatsApp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            final Uri _whatsappLaunchUri =
                Uri.parse('https://wa.me/916303205936');
            await launch(_whatsappLaunchUri.toString());
          },
        ),
      ],
    );
  }
}
