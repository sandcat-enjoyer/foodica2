import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Product Details", style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: const Text("Product Details", style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 30.0
        )),

        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    height: 150.0,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Product Name", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                            )),
                            SizedBox(
                              height: 10.0
                            ),
                            Text("actual product name", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ))
                          ],)
                        )
                      ),
                    )
                  )
                ],
              ),),)
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    height: 150.0,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Allergens", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                            )),
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Possible allergens", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ))
                          ],)
                        )
                      ),
                    )
                  )
                ],
              ),),)
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    height: 150.0,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Saturated Fats", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                            )),
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Saturated fats level in grams", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ))
                          ],)
                        )
                      ),
                    )
                  )
                ],
              ),),)
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    height: 150.0,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Salt", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                            )),
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Salt level in grams", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ))
                          ],)
                        )
                      ),
                    )
                  )
                ],
              ),),)
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    height: 150.0,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Fat", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                            )),
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Level of fat in grams", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ))
                          ],)
                        )
                      ),
                    )
                  )
                ],
              ),),)
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    height: 150.0,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Sugar", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                            )),
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Sugar levels in grams", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ))
                          ],)
                        )
                      ),
                    )
                  )
                ],
              ),),)
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    height: 150.0,
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            SizedBox(
                              height: 10.0
                            ),
                            Text("Nutriscore", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                            )),
                            SizedBox(
                              height: 10.0
                            ),
                            Text("yass", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ))
                          ],)
                        )
                      ),
                    )
                  )
                ],
              ),),)
          ],
        ),
          ],
        ),
      )
    );
  }

}