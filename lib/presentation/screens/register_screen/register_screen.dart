// ignore_for_file: avoid_print

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/presentation/providers/bool_provider.dart';
import 'package:chat_app/presentation/providers/register_form_state.dart';
import 'package:chat_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';

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
                  RegisterForm(),
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

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        clipBehavior: Clip.none,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: message,
          contentType: ContentType.failure,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);
    final passwordVisible = ref.watch(boolProvider);
    final size = MediaQuery.of(context).size;

    ref.listen(authProvider, (previus, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackBar(context, next.errorMessage);
    });

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * .03,
      ),
      child: SizedBox(
        width: size.width * .8,
        child: Column(
          children: [
            CustomTextFormField(
              keyboardType: TextInputType.emailAddress,
              onChanged:
                  ref.read(registerFormProvider.notifier).onFullNameChanged,
              errorMessage: registerForm.isPosting
                  ? registerForm.fullName.errorMessage
                  : null,
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
              keyboardType: TextInputType.emailAddress,
              onChanged: ref.read(registerFormProvider.notifier).onEmailChanged,
              errorMessage: registerForm.isPosting
                  ? registerForm.email.errorMessage
                  : null,
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
              keyboardType: TextInputType.text,
              hint: 'Password',
              obscureText: passwordVisible,
              onChanged:
                  ref.read(registerFormProvider.notifier).onPasswordChanged,
              errorMessage: registerForm.isPosting
                  ? registerForm.password.errorMessage
                  : null,
              prefixIcon: IconButton(
                onPressed: () {
                  ref.read(boolProvider.notifier).state = !passwordVisible;
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
                      ),
              ),
            ),
            SizedBox(
              height: size.height * .04,
            ),
            CustomFilledButton(
              text: 'Crear cuenta',
              style: TextStyle(
                fontFamily: AppTheme.poppinsRegular,
                fontSize: size.width * .04,
              ),
              buttonColor: Colors.blue[600],
              fixedSize: Size(size.width * .5, size.height * .04),
              onPressed: registerForm.isPosting
                  ? null
                  : () {
                      try {
                        ref.read(registerFormProvider.notifier).onFormSubmit();
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.go('/users');
                      } catch (e) {
                        Exception(e);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

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
