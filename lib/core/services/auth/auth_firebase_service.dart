import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:to_do_list/core/models/user_data.dart';
import 'package:to_do_list/core/services/auth/auth_service.dart';

class AuthFirebaseService implements AuthService {
  static UserData? _currentUser;

  static final _userStream = Stream<UserData?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toUserData(user);
      controller.add(_currentUser);
    }
  });

  @override
  UserData? get currentUser => _currentUser;

  @override
  Stream<UserData?> get userChanges => _userStream;

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    // Ignorar o AppCheck em desenvolcimento
    // await FirebaseAppCheck.instance.activate(
    //   webRecaptchaSiteKey: 'fake-key',
    // );

    // Ignorar Warning de "X-Firebase-Locale"
    auth.setLanguageCode('pt');

    // Criando credenciais
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return;

    // Upload da foto de usuário
    final imageName = '${credential.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);

    // Atualizando atributos do usuário
    await credential.user?.updateDisplayName(name);
    await credential.user?.updateDisplayName(name);

    // Fazendo o login do usuário
    await login(email, password);

    // Salvando usuário no banco
    await _saveUserInDataBase(_toUserData(credential.user!, imageUrl));

    await signup.delete();
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static UserData _toUserData(User user, [String? imageUrl]) {
    return UserData(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);

    await imageRef.putFile(image).whenComplete(() {});

    return await imageRef.getDownloadURL();
  }

  Future<void> _saveUserInDataBase(UserData user) async {
    final storage = FirebaseFirestore.instance;
    final docRef = storage.collection('users').doc(user.id);

    return await docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
    });
  }
}
