import 'package:flutter/material.dart';
import 'package:frontend/constent/inputText.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/services/updateBio.dart';
import 'package:provider/provider.dart';

class UpdateBioPage extends StatefulWidget {
  @override
  _UpdateBioPageState createState() => _UpdateBioPageState();
}

class _UpdateBioPageState extends State<UpdateBioPage> {
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Bio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            inputTextt(
              label: 'Bio',
              icon: Icons.info_outline,
              controller: bioController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  print("Updating Bio...");
                  if (userProvider.user != null) {
                    await UpdateBio.updateBio(
                      userId: userProvider.user!.id,
                      bio: bioController.text,
                      context: context,
                    );
                    print("Bio Updated Successfully!");
                  } else {
                    print("User is null. Unable to update bio.");
                  }
                } catch (error) {
                  print("Error updating bio: $error");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Update Bio',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
