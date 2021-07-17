import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/custom_button.dart';
import 'package:trailya/app/widgets/custom_button_with_asset.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/model/signin_bloc.dart';
import 'package:trailya/services/auth.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({required this.bloc, required this.physicalDevice});

  final bool physicalDevice;
  final SignInBloc bloc;

  static Widget create(BuildContext context, bool physicalDevice) {
    final auth = Provider.of<FirebaseAuthentication>(context, listen: false);

    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (ctxt, bloc, _) => SignInScreen(
          bloc: bloc,
          physicalDevice: physicalDevice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('trailya'),
        ),
        elevation: 5.0,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) => _buildContent(context, snapshot.data!),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) => Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeader(isLoading),
            SizedBox(height: 50.0),
            CustomButtonWithAsset(
              text: 'Sign in with Google',
              asset: 'assets/google-logo.png',
              color: Colors.white,
              textColor: Colors.black87,
              onPressed: () async {
                if (isLoading) return;
                await _signInWithGoogle(context);
              },
            ),
            SizedBox(height: 8.0),
            if (!physicalDevice)
              CustomButton(
                color: Colors.indigo.shade100,
                onPressed: () async {
                  if (isLoading) return;
                  await _signInAnonymously(context);
                },
                child: Text(
                  'Go Anonymous',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Waiting();
    }

    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }

    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }
}
