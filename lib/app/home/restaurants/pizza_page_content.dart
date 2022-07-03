import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PizzaPageContent extends StatelessWidget {
  const PizzaPageContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('restaurants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Wystąpił błąd'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Trwa ładowanie danych'),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView(children: [
            for (final document in documents) ...[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(document['name']),
                        Text(document['pizza']),
                      ],
                    ),
                    Text(document['rating'].toString()),
                  ],
                ),
              ),
            ]
          ]);
        });
  }
}
