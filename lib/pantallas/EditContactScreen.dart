import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:proy_fire/pantallas/add_screen.dart';
import 'package:proy_fire/pantallas/contactos.dart';

class EditContactScreen extends StatefulWidget {
  final String? contactId;
  final String contactName;
  final String contactNumber;
  final String contactType;

  EditContactScreen({
    required this.contactId,
    required this.contactName,
    required this.contactNumber,
    required this.contactType,
  });

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.ref();
  late TextEditingController _nameController, _numberController;
  late String _typeSelected = '';
  late DatabaseReference _ref;

  String? _key;
  String _name = '';
  String _number = '';
  String _type = '';

  @override
  void initState() {
    _key = widget.contactId;
    _name = widget.contactName;
    _number = widget.contactNumber;
    _type = widget.contactType;
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.ref().child('Contacts');
  }

  void writeNewPost(String? key, String name, String number, String type) async {
    // A post entry.
    final postData = {
      'key': key,
      'name': name,
      'number': number,
      'type': type,
    };

    // Get a key for a new Post.
    final newPostKey =
        FirebaseDatabase.instance.ref().child('posts').push().key;

    // Write the new post's data simultaneously in the posts list and the
    // user's post list.
    final Map<String, Map> updates = {};
    updates['/posts/$newPostKey'] = postData;
    updates['/user-posts/$key/$newPostKey'] = postData;

    return FirebaseDatabase.instance.ref().update(updates);
  }


  Widget _buildContactType (String title){
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _typeSelected == title? Colors.green : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(title, style: TextStyle(fontSize: 18, color: Colors.white),),
        ),
      ),
      onTap: (){
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Editar Contacto"
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter name",
                prefix: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _numberController,
              decoration: InputDecoration(
                hintText: "Enter number",
                prefix: Icon(
                  Icons.phone_android,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildContactType('Trabajo'),
                  SizedBox(width: 10,),
                  _buildContactType('Familia'),
                  SizedBox(width: 10,),
                  _buildContactType('Amigos'),
                  SizedBox(width: 10,),
                  _buildContactType('Otros'),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            SizedBox(height: 25,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                child: Text("Actualizar contacto",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                ),
                onPressed: (){
                  writeNewPost(_key, _nameController.toString(), _numberController.toString(), _typeSelected);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
