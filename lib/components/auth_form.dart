import 'package:flutter/material.dart';
import 'package:to_do_list/models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formData = AuthFormData();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: Column(
            children: [
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
                onPressed: () {},
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
