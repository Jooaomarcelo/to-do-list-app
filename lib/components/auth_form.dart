import 'dart:io';

import 'package:flutter/material.dart';
import 'package:to_do_list/components/user_image_picker.dart';
import 'package:to_do_list/core/models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({
    required this.onSubmit,
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formData = AuthFormData();

  final _formKey = GlobalKey<FormState>();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_formData.image == null && _formData.isSignup) {
      return _showError('Imagem não selecionada.');
    }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_formData.isSignup)
                UserImagePicker(onImagePick: _handleImagePick),
              if (_formData.isSignup)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _formData.name,
                  onChanged: (name) => _formData.name = name,
                  decoration: InputDecoration(
                    labelText: 'Nome de Usuário',
                  ),
                  validator: (textField) {
                    final name = textField ?? '';

                    if (name.trim().isEmpty) {
                      return 'Nome de Usuário não pode ser vazio.';
                    }

                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _formData.email,
                onChanged: (email) => _formData.email = email,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (textField) {
                  final email = textField ?? '';

                  if (email.trim().isEmpty) {
                    return 'Nome de Usuário não pode ser vazio.';
                  }

                  if (!email.contains('@')) {
                    return 'Email inválido.';
                  }

                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (textField) {
                  final password = textField ?? '';

                  if (password.trim().length < 6) {
                    return 'A senha deve conter no mínimo 6 caractéres.';
                  }

                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                onPressed: () => setState(() => _formData.toggleMode()),
                child: Text(_formData.isLogin
                    ? 'Novo usuário?'
                    : 'Já possui uma conta?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
