import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:supabse_playground/store/auth_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthController authStore = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  const Text(
                    'Sign in into your Notely account',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  // Email Field
                  FormBuilderTextField(
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    name: 'email',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  const SizedBox(height: 16.0),

                  // Password Field
                  FormBuilderTextField(
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    name: 'password',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.password(checkNullOrEmpty: true),
                    ]),
                  ),
                  const SizedBox(height: 24.0),

                  // Login Button
                  InkWell(
                    onTap: () {
                      // Validate and save the form values
                      _formKey.currentState?.saveAndValidate(
                        autoScrollWhenFocusOnInvalid: true,
                        focusOnInvalid: true,
                      );

                      // debugPrint('current state = ${_formKey.currentState?.value.toString()}');

                      // On another side, can access all field values without saving form with instantValues
                      _formKey.currentState?.validate();
                      if (_formKey.currentState?.validate() == true) {
                        debugPrint('Validation was successful');

                        authStore.loginLocal(
                            _formKey.currentState?.instantValue['email']
                                    .toString() ??
                                '',
                            _formKey.currentState?.instantValue['password']
                                    .toString() ??
                                '');
                      }
                      debugPrint(_formKey.currentState?.instantValue['email']);
                    },
                    child: authStore.isLoggingInLocal.value
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  InkWell(
                    onTap: () {
                      authStore.googleSignIn();
                    },
                    child: authStore.isLoggingInGoogle.value
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.grey)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                    image:
                                        AssetImage('assets/images/google.png')),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'SIGN IN WITH GOOGLE',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                  ),

                  InkWell(
                    onTap: () {
                      Get.toNamed('/signup');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            text: 'Dont have an account ',
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Tap here',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40.0),

                  // Google Sign-In Button
                  // SizedBox(
                  //   height: 60,
                  //   child: OutlinedButton.icon(
                  //     onPressed: () {
                  //       // Handle Google Sign-In
                  //     },
                  //     icon: const Icon(Icons.login, color: Colors.red),
                  //     label: const Text('Sign in with Google'),
                  //     style: OutlinedButton.styleFrom(
                  //       side: const BorderSide(color: Colors.grey),
                  //     ),
                  //   ),
                  // ),

                  // logo
                  const Center(
                    child: Image(image: AssetImage('assets/images/logo.png')),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
