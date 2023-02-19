import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:proy_fire/pantallasLibros/add_screen.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  late Query _ref;
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance.ref().child('Books').orderByChild('name');
  }

  Widget _buildBookItem({required Map book}){

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
                        Icons.book,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        book['name'],
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
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        book['author'],
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
                        Icons.house_siding_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        book['editorial'],
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
                        Icons.date_range,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        book['date'],
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () async {
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
                      String? key = await optainValue(book['name'], book['author'], book['editorial'], book['date']);
                      deleteBook(key);
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
        title: Text("Librería"),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            dynamic book = snapshot.value;
            return _buildBookItem(book: book);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_){
            return AddBooks();
          }));
        },
      ),
    );
  }

  Future<void> deleteBook(String? key) async {
    final booksRef = databaseReference.child('Books');
    await booksRef.child(key!).remove();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Libro eliminado')),
    );
  }


  Future<String?> optainValue(String name, String author, String editorial, String date) async {
    final booksRef = databaseReference.child('Books');
    DatabaseEvent event = (await booksRef.once()) as DatabaseEvent;
    Map<dynamic, dynamic>? books = event.snapshot.value as Map?;
    String? keyString;
    books!.forEach((key, value) {
      if (value['name'] == name && value['author'] == author && value['editorial'] == editorial && value['date'] == date) {
        keyString = key.toString();
      }
    });
    return keyString;
  }


}
