import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({Key? key}) : super(key: key);

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  late TextEditingController _nameController, _numberController;
  late String _typeSelected = '';
  late DatabaseReference _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.ref().child('Contacts');
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
          "Guardar Contacto"
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
                child: Text("Guardar contacto",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),
                ),
                onPressed: (){
                  saveContact();
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
  void saveContact(){
    String name = _nameController.text;
    String number = _numberController.text;
    Map<String,String> contact = {
      'name': name,
      'number': "+52"+number,
      'type': _typeSelected,
    };
    _ref.push().set(contact).then((value){
      Navigator.pop(context);
    });
  }
}
