import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabse_playground/pages/add_note.dart';
import 'package:supabse_playground/widgets/drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> notes = ['Gotta Make Notes', 'Code Flutter in coming years'];

  final _noteStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']).eq('user_id', Supabase.instance.client.auth.currentUser!.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
        appBar: AppBar(
          title: const Text(
            'My Notes',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddNote(
                      isEdit: false,
                    );
                  }));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _noteStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.black));
              }

              final notes = snapshot.data ?? [];

              return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final note = notes[index]['body'];
                    // Parse the created_at string into a DateTime
                    final createdAt =
                        DateTime.parse(notes[index]['created_at']);
                    final formattedDate = Moment(createdAt).calendar();

                    return InkWell(
                      onTap: () {
                        Get.toNamed('/add-note');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddNote(
                            isEdit: true,
                            note: notes[index],
                          );
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(formattedDate,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(
                                note,
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for overflow
                                maxLines: 4, // Number of lines to display
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
