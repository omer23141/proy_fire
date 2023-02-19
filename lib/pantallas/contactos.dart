import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:proy_fire/pantallas/add_screen.dart';
import 'package:proy_fire/pantallas/EditContactScreen.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late Query _ref;
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance.ref().child('Contacts').orderByChild('name');
  }

  Widget _buildContactItem({required Map contact}){
    Color typeColor = getTypeColor(contact['type']);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      height: 200,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        contact['name'],
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_iphone,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        contact['number'],
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(width: 6,),
                      Text(
                        contact['type'],
                        style: TextStyle(
                            fontSize: 16,
                            color: getTypeColor(contact['type']),
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      String? key = await optainValue(contact['name'], contact['number'], contact['type']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditContactScreen(contactId: key, contactName: contact['name'], contactNumber: contact['number'], contactType: contact['type'])),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      String? key = await optainValue(contact['name'], contact['number'], contact['type']);
                      deleteContact(key);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            dynamic contact = snapshot.value;
            return _buildContactItem(contact: contact);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_){
            return AddContacts();
          }));
        },
      ),
    );
  }

  Color getTypeColor(String type){
    Color color = Theme.of(context).colorScheme.secondary;

    if(type == 'Trabajo'){
      color = Colors.brown;
    }

    if(type == 'Familia'){
      color = Colors.green;
    }

    if(type == 'Amigos'){
      color = Colors.teal;
    }

    return color;
  }

  Future<void> deleteContact(String? key) async {
    final contactsRef = databaseReference.child('Contacts');
    await contactsRef.child(key!).remove();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contacto eliminado')),
    );
  }


  Future<String?> optainValue(String name, String number, String type) async {
    final contactsRef = databaseReference.child('Contacts');
    DatabaseEvent event = (await contactsRef.once()) as DatabaseEvent;
    Map<dynamic, dynamic>? contacts = event.snapshot.value as Map?;
    String? keyString;
    contacts!.forEach((key, value) {
      if (value['name'] == name && value['number'] == number && value['type'] == type) {
        keyString = key.toString();
      }
    });
    return keyString;
  }


}
