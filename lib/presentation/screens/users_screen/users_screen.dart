import 'package:chat_app/config/config.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:chat_app/presentation/screens/users_screen/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends ConsumerState<UserScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    UserModel(
      uid: '1',
      name: 'Claire',
      email: 'claire123@gmail.com',
      online: true,
    ),
    UserModel(
      uid: '2',
      name: 'Yocelin',
      email: 'yocelin.yi.123@gmail.com',
      online: false,
    ),
    UserModel(
      uid: '3',
      name: 'Paola',
      email: 'pacos123@gmail.com',
      online: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UsersScreen'),
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          },
          icon: const Icon(
            Icons.exit_to_app_outlined,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: size.width * .04,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue[400],
            ),

            // Icon(
            //   Icons.offline_bolt,
            //   color: Colors.red[800],
            // ),
          ),
          IconButton(
            onPressed: () {
              context.push('/theme-changer');
            },
            icon: const Icon(Icons.palette_outlined),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: const WaterDropMaterialHeader(),
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UserListTile(users[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: users.length,
    );
  }

  _loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    refreshController.refreshCompleted();
  }
}

//* UserListTile
class _UserListTile extends StatelessWidget {
  final UserModel user;

  const _UserListTile(this.user);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () {
        context.push('/chat');
      },
      title: Text(
        user.name,
        style: TextStyle(
          fontFamily: AppTheme.poppinsRegular,
          fontSize: size.width * .04,
        ),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(
          fontFamily: AppTheme.poppinsRegular,
          fontSize: size.width * .025,
        ),
      ),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
          width: size.width * .03,
          height: size.width * .03,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: user.online ? Colors.green : Colors.red,
          )),
    );
  }
}
// !
