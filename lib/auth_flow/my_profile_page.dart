import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samsarah/auth_flow/activate_voucher.dart';
import 'package:samsarah/auth_flow/profile_photo.dart';
import 'package:samsarah/auth_flow/sign_in.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/services/storage_service.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/my_text_form_field.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final auth = AuthService().firebaseAuth;
  final store = Database();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الصفحة الشخصية"),
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();
                if (mounted) {
                  pushReplacement(context, const SignInPage());
                }
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  ProfilePhoto(
                      username: auth.currentUser!.displayName,
                      radius: MediaQuery.of(context).size.width * 3 / 10,
                      imagePath: auth.currentUser!.photoURL),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton(
                      onPressed: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          await StorageService().updateProfile(image.path);
                          setState(() {});
                        }
                      },
                      backgroundColor: Colors.green,
                      shape: const CircleBorder(),
                      heroTag: "GOGOGAGA",
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                auth.currentUser!.displayName!,
                style: const TextStyle(fontSize: 25, color: Colors.black87),
              ),
              IconButton(onPressed: editUserName, icon: const Icon(Icons.edit))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Colors.green.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FutureBuilder(
                      future: AuthService().getCurrency(),
                      builder: (_, snapshot) =>
                          snapshot.connectionState == ConnectionState.done
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "الرصيد :${snapshot.data!}",
                                    style: const TextStyle(
                                        fontSize: 30, color: Colors.green),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                    ),
                    FloatingActionButton(
                      onPressed: () =>
                          push(context, const ActivateVoucherPage()),
                      backgroundColor: Colors.green,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void editUserName() async {
    final key = GlobalKey<FormState>();
    String value = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          actions: [
            MyButton(
                onPressed: () => pop(context, null),
                raised: false,
                title: "رجوع"),
            MyButton(
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    key.currentState!.save();
                    await auth.currentUser!.updateDisplayName(value);
                    await store.accountCollection
                        .doc(auth.currentUser!.uid)
                        .update({"username": auth.currentUser!.displayName!});
                    if (context.mounted) {
                      pop(context, null);
                    }
                  }
                },
                raised: true,
                title: "تغيير الاسم"),
          ],
          title: const Text("تغيير الاسم"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: key,
                child: MyTextFormField(
                    initialValue: auth.currentUser!.displayName,
                    onSaved: (result) {
                      value = result!;
                    },
                    validator: (value) =>
                        value == null || value == "" ? "هذا الحقل فارغ" : null,
                    keyboardType: TextInputType.name,
                    labelText: "الاسم الجديد",
                    pppType: PPPType.createNew),
              ),
            ],
          )),
    );
  }
}
