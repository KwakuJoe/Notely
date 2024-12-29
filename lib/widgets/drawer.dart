import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabse_playground/store/auth_store.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});
  

  @override
  Widget build(BuildContext context) {
    final AuthController authStore = Get.put(AuthController());

    return Obx(() => Drawer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 55),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('${authStore.userId}'),
                // Text('${authStore.user}'),

                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      authStore.displayUserInfo()?.userMetadata!['full_name'][0]
                          .toString()
                          .toUpperCase() ?? '',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                      authStore.displayUserInfo()?.userMetadata!['full_name']
                          .toString() ?? '',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text(authStore.displayUserInfo()!.email.toString()),
                ),

                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20)),
                    child: authStore.isLoggingOut.value
                        ? const ListTile(
                            leading:
                                CircularProgressIndicator(color: Colors.black),
                            title: Text('Logging out .....'),
                          )
                        : ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            subtitle:
                                const Text('Logout of of your notely account'),
                            onTap: () {
                              authStore.logout();
                            }))
              ],
            ),
          ),
        ));
  }
}
