import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: SizedBox(
              height: size.height * .9,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(
                    title: 'Crear una cuenta',
                  ),
                  _Form(),
                  Labels(
                    questionText: '¿Ya tienes una cuenta?',
                    textButton: 'Ingresa ahora!',
                    route: '/login',
                  ),
                  _TermsAndConditions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//* Formulario de login
class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final TextEditingController userNameController =
      TextEditingController(text: '');
  final TextEditingController userEmailController =
      TextEditingController(text: '');
  final TextEditingController userPasswordController =
      TextEditingController(text: '');

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * .03,
      ),
      child: SizedBox(
        width: size.width * .8,
        child: Column(
          children: [
            CustomTextFormField(
              controller: userNameController,
              keyboardType: TextInputType.emailAddress,
              hint: 'Nombre',
              prefixIcon: Icon(
                Icons.person_outlined,
                color: Colors.black45,
                size: size.width * .05,
              ),
            ),
            SizedBox(
              height: size.height * .02,
            ),
            CustomTextFormField(
              controller: userEmailController,
              keyboardType: TextInputType.emailAddress,
              hint: 'Email',
              prefixIcon: Icon(
                Icons.mail_outline_outlined,
                color: Colors.black45,
                size: size.width * .05,
              ),
            ),
            SizedBox(
              height: size.height * .02,
            ),
            CustomTextFormField(
              controller: userPasswordController,
              keyboardType: TextInputType.text,
              hint: 'Password',
              obscureText: passwordVisible,
              prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon: passwordVisible
                      ? Icon(
                          Icons.lock_outline,
                          color: Colors.black45,
                          size: size.width * .05,
                        )
                      : Icon(
                          Icons.lock_open_outlined,
                          color: Colors.black45,
                          size: size.width * .05,
                        )),
            ),
            SizedBox(
              height: size.height * .04,
            ),
            CustomFilledButton(
              text: 'Ingresar',
              style: TextStyle(
                fontFamily: AppTheme.poppinsRegular,
                fontSize: size.width * .04,
              ),
              buttonColor: Colors.blue[600],
              fixedSize: Size(size.width * .5, size.height * .04),
              onPressed: () {
                print(
                    'email: ${userEmailController.text} , password: ${userPasswordController.text}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
// !

class _TermsAndConditions extends StatelessWidget {
  const _TermsAndConditions();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TextButton(
      onPressed: () {},
      child: Text(
        'Términos y condiciones de uso',
        style: TextStyle(
          fontFamily: AppTheme.poppinsRegular,
          fontSize: size.width * .04,
          color: Colors.black54,
        ),
      ),
    );
  }
}
