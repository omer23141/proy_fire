import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AddBooks extends StatefulWidget {
  const AddBooks({Key? key}) : super(key: key);

  @override
  State<AddBooks> createState() => _AddBooksState();
}

class _AddBooksState extends State<AddBooks> {
  late TextEditingController _nameController, _authorController, _editorialController, _dateController;
  late DatabaseReference _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _authorController = TextEditingController();
    _editorialController = TextEditingController();
    _dateController = TextEditingController();
    _ref = FirebaseDatabase.instance.ref().child('Books');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Guardar Libro"
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
                  Icons.book,
                  size: 30,
                ),
                fillColor: Colors.green,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                hintText: "Ingrese autor",
                prefix: Icon(
                  Icons.person,
                  size: 30,
                ),
                fillColor: Colors.green,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _editorialController,
              decoration: InputDecoration(
                hintText: "Ingrese la editorial",
                prefix: Icon(
                  Icons.house_siding_sharp,
                  size: 30,
                ),
                fillColor: Colors.green,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                hintText: "Ingrese la fecha de publicación",
                prefix: Icon(
                  Icons.date_range,
                  size: 30,
                ),
                fillColor: Colors.green,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 25,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                child: Text("Guardar libro",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),
                ),
                onPressed: (){
                  saveBook();
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
  void saveBook(){
    String name = _nameController.text;
    String author = _authorController.text;
    String editorial = _editorialController.text;
    String date = _dateController.text;
    Map<String,String> book = {
      'name': name,
      'author': author,
      'editorial': editorial,
      'date': date,
    };
    _ref.push().set(book).then((value){
      Navigator.pop(context);
    });
  }
}
