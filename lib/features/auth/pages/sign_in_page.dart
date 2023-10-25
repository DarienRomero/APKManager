import 'package:apk_manager/core/utils.dart';
import 'package:apk_manager/core/validators.dart';
import 'package:apk_manager/features/apps/pages/app_home_page.dart';
import 'package:apk_manager/features/auth/controllers/auth_controller.dart';
import 'package:apk_manager/features/auth/models/user_model.dart';
import 'package:apk_manager/features/auth/providers/user_provider.dart';
import 'package:apk_manager/features/common/controllers/notification_controller.dart';
import 'package:apk_manager/features/common/models/error_response.dart';
import 'package:apk_manager/features/common/widgets/alerts.dart';
import 'package:apk_manager/features/common/widgets/custom_button.dart';
import 'package:apk_manager/features/common/widgets/custom_text_field.dart';
import 'package:apk_manager/features/common/widgets/page_loader.dart';
import 'package:apk_manager/features/common/widgets/scaffold_wrapper.dart';
import 'package:apk_manager/features/common/widgets/v_spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final authController = AuthController();
  final notificationController = NotificationController();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  String emailError = "";
  String passwordError = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      onWillPop: () => Future.value(false),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: mqWidth(context, 5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VSpacing(15),
                  Text("APK Manager", style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                  )),
                  const VSpacing(20),
                  CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    errorMessage: emailError,
                    label: "Email",
                  ),
                  const VSpacing(3),
                  CustomTextField(
                    controller: passwordController,
                    errorMessage: passwordError,
                    label: "Contraseña",
                  ),
                  const VSpacing(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        onPressed: onSignIn,
                        label: "Iniciar sesión", 
                        widthPer: 60,
                        color: Theme.of(context).primaryColor
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          PageLoader(
            loading: loading, 
            message: "Iniciando sesión"
          )
        ],
      )
    );
  }
  Future<void> onSignIn() async {
    emailError = emailValidator(emailController.text);
    passwordError = passwordValidator(passwordController.text);
    if(emailError.isNotEmpty || passwordError.isNotEmpty){
      setState(() {});
      return;
    }
    if(loading == true) return;
    emailFocus.unfocus();
    passwordFocus.unfocus();
    setState(() {
      loading = true;
    });
    final response = await authController.signInUserEmailPassword(emailController.text, passwordController.text);
    if(response is ErrorResponse){
      setState(() {
        loading = false;
      });
      if(mounted){
        showErrorAlert(
          context: context, 
          title: "Ocurrió un error", 
          message: [response.message]
        );
      }
      return;
    }
    final respTemp = response as User;
    final responseUser = await authController.fetchUserById(respTemp.uid);
    if(responseUser is ErrorResponse){
      setState(() {
        loading = false;
      });
      if(mounted){
        showErrorAlert(
          context: context, 
          title: "Ocurrió un error", 
          message: [responseUser.message]
        );
      }
      await authController.signOut();
      return;
    }
    final data = responseUser as UserModel;
    if(!data.enabled){
      setState(() {
        loading = false;
      });
      if(mounted){
        showErrorAlert(
          context: context, 
          title: "Estimado usuario", 
          message: ["Su cuenta se encuentra deshabilitada. Comuníquese con el administrador para más información"]
        );
      }
      await authController.signOut();
      return;
    }
    await notificationController.subscribeToTopics(data.appsEnabled);
    setState(() {
      loading = false;
    });
    if(mounted){
      Provider.of<UserProvider>(context, listen: false).setNewUser(data);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AppHomePage()), (route) => false);
    }
  }
}