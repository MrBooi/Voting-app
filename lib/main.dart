import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main () => runApp(VotingPage());

 class VotingPage extends StatelessWidget {
   VotingPage();
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Election Survey',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const VotingHomePage(title:'SOUTH AFRICA\'S POLITICAL PARTIES'),
    );
  }

 }

  class VotingHomePage extends StatelessWidget  {
    const VotingHomePage ({this.title}) :super();
    final String title;



   Widget _buildListItem(BuildContext context,DocumentSnapshot document){
     return ListTile(
       title: Row(
         children: <Widget>[
           Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
           ),
           Container(
             decoration: const BoxDecoration(
               color: Color(0xffdddff),
             ),
             padding: const EdgeInsets.all(10.0),
             child: Text(
              document['votes'].toString(),
               style: Theme.of(context).textTheme.display1,
             ),
           )
         ],
       ),
       onTap: (){
        Firestore.instance.runTransaction((transaction) async{
         DocumentSnapshot freshData = await transaction.get(document.reference);
         await transaction.update(freshData.reference, {
            'votes':freshData['votes']+1,
         });
        });
      
       },
     );
   }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title,style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('politicalparties').snapshots(),
        builder:(context, snapshot){
          if(!snapshot.hasData) return const Text("Loading");
         return     ListView.builder(
          itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index) => 
           _buildListItem(context ,snapshot.data.documents[index]),
         );
        }
        ),
      );
  }
    
  }