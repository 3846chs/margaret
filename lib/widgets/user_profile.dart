import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
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
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_l_gap),
                  child: Image.network(
                    "https://www.rnx.kr/news/photo/201805/67765_53720_457.jpg", // 방탄 지민 사진을 임시로 사용하였음. value.data.photoUrl 같은걸로 사용자 사진 가져와야 함.
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Text(
                    value.data.nickname,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                ProfileBasicInfo(
                    '나이',
                    (DateTime.now().year - value.data.birthYear + 1)
                        .toString()),
                ProfileBasicInfo('지역', value.data.region),
                ProfileBasicInfo('직업', value.data.job),
                ProfileBasicInfo('키', value.data.height.toString()),

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
