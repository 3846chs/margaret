import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:datingapp/widgets/profile_widgets/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<MyUserData>(builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(common_l_gap),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: value.userData.profiles
                        .map((path) => FutureBuilder<String>(
                            future:
                                storageProvider.getImageUri("profiles/$path"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                print(path);
                                return Padding(
                                  padding: const EdgeInsets.all(common_gap),
                                  child: Image.network(
                                    snapshot.data,
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return const CircularProgressIndicator();
                            }))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Text(
                    value.userData.nickname,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                ProfileBasicInfo(
                    '나이',
                    (DateTime.now().year - value.userData.birthYear + 1)
                        .toString()),
                ProfileBasicInfo('지역', value.userData.region),
                ProfileBasicInfo('직업', value.userData.job),
                ProfileBasicInfo('키', value.userData.height.toString()),

                //_builTest(),
                Padding(
                  padding: const EdgeInsets.all(common_l_gap),
                  child: Center(
                    child: FlatButton(
                      child: const Text(
                        '호감 보내기',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: null,
                      color: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      disabledColor: Colors.blue[100],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
