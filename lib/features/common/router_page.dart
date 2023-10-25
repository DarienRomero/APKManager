import 'package:apk_manager/features/apps/pages/app_home_page.dart';
import 'package:apk_manager/features/auth/controllers/auth_controller.dart';
import 'package:apk_manager/features/auth/pages/sign_in_page.dart';
import 'package:apk_manager/features/auth/providers/user_provider.dart';
import 'package:apk_manager/features/common/models/error_response.dart';
import 'package:apk_manager/features/common/widgets/scaffold_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  final authController = AuthController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSession();
    });
  }

  Future<void> loadSession() async {
    final resp = await Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    if(resp is ErrorResponse){
      if(mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInPage()), (route) => false);
      }
    }else{
      if(mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AppHomePage()), (route) => false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return const ScaffoldWrapper(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}