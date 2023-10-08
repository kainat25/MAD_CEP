import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventvista/edit_event.dart';
import 'package:eventvista/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:eventvista/event_creation.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 39, 47, 82),
        title: Text('Upcoming Events'),
      ),
      body: EventList(screenWidth: screenWidth, screenHeight: screenHeight),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EventCreation()),
            );
          }
          if (index == 2) {}
          if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProfileData()),
            );
          }
        },
        selectedItemColor: Color.fromARGB(255, 39, 47, 82),
        unselectedItemColor: Color.fromARGB(255, 39, 47, 82),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
      ),
    );
  }
}

class EventList extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  EventList({required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('date_time')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final events = snapshot.data!.docs;

        if (events.isEmpty) {
          return Center(
            child: Text('No events available.'),
          );
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final eventData = event.data() as Map<String, dynamic>;

            void deleteEvent() {
              FirebaseFirestore.instance
                  .collection('events')
                  .doc(event.id)
                  .delete()
                  .then((_) {})
                  .catchError((error) {
                print('Error deleting event: $error');
              });
            }

            void editEvent(BuildContext context, String eventId) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditEvent(eventId: eventId),
                ),
              );
            }

            return Card(
              child: ListTile(
                title: Text(eventData['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${eventData['description']}'),
                    Text('Date: ${eventData['date']}'),
                    Text('Time: ${eventData['time']}'),
                    Text('Location: ${eventData['location']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => editEvent(context, event.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: deleteEvent,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
