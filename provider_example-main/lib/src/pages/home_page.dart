import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Consumer<UserProvider>(
        builder: (_, userProvider, __) {
          if (_userProvider.userState is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (_userProvider.userState is Loaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.separated(
                separatorBuilder: (_, __) => Divider(),
                itemCount: userProvider.userModel.length,
                itemBuilder: (context, index) {
                  final data = userProvider.userModel[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${data.id}')),
                    title: Text(data.name),
                    subtitle: Text(data.email),
                  );
                },
              ),
            );
          } else if (_userProvider.userState is Error) {
            return const Center(child: Text('Failed to fetch users!'));
          } else {
            return Container();
          }
          // switch (userProvider.userState) {
          //   case UserState.loading:
          //     return const Center(child: CircularProgressIndicator());
          //     break;
          //   case UserState.loaded:
          //     return ListView.separated(
          //       separatorBuilder: (_, __) => Divider(),
          //       itemCount: userProvider.userModel.length,
          //       itemBuilder: (context, index) {
          //         final data = userProvider.userModel[index];
          //         return ListTile(
          //           leading: CircleAvatar(child: Text('${data.id}')),
          //           title: Text(data.name),
          //           subtitle: Text(data.email),
          //         );
          //       },
          //     );
          //     break;
          //   case UserState.error:
          //     return const Center(child: Text('Failed to fetch users!'));
          //     break;
          //   default:
          //     return Container();
          // }
        },
      ),
    );
  }

  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    Timer(new Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future;
  }
}
