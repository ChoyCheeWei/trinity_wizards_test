import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trinity_wizards_test/injector.dart';
import 'package:trinity_wizards_test/models/contact_model.dart';

import '../../cubit/contact_cubit.dart';

class ContactDetailsPage extends StatefulWidget {
  final ContactModel contact;

  const ContactDetailsPage({
    super.key,
    required this.contact,
  });

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  late ContactModel contact;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    _firstNameController.text = contact.firstName;
    _lastNameController.text = contact.lastName;
    _emailController.text = contact.email;
    _dobController.text = contact.dob;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppBarWidget(),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _getAvatarWidget(),
              const SizedBox(height: 24),
              _getMainInfoLabelWidget(),
              const SizedBox(height: 16),
              _getMainInfoContentWidget(),
              _getSubInfoLabelWidget(),
              const SizedBox(height: 16),
              _getEmailInputWidget(),
              _getDividerWidget(),
              _getDobInputWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _getDobInputWidget() {
    return Row(
      children: [
        const Text('DOB:'),
        const Spacer(),
        SizedBox(
          width: 240,
          child: TextFormField(
            controller: _dobController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    _dobController.text = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                  }
                },
                child: const Icon(Icons.calendar_month),
              ),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getEmailInputWidget() {
    return Row(
      children: [
        const Text('Email:'),
        const Spacer(),
        SizedBox(
          width: 240,
          child: TextFormField(
            controller: _emailController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getSubInfoLabelWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: const Text(
        'Sub Information',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _getMainInfoContentWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              const Text('First Name:'),
              const Spacer(),
              SizedBox(
                width: 240,
                child: TextFormField(
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          _getDividerWidget(),
          Row(
            children: [
              const Text('Last Name:'),
              const Spacer(),
              SizedBox(
                width: 240,
                child: TextFormField(
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          _getDividerWidget(),
        ],
      ),
    );
  }

  Widget _getMainInfoLabelWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: const Text(
        'Main Information',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _getAvatarWidget() {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.orange,
    );
  }

  Widget _getDividerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Divider(thickness: 1.0),
    );
  }

  AppBar _getAppBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            await injector<ContactCubit>().updateContact(
              item: ContactModel(
                id: contact.id,
                firstName: _firstNameController.text.trim(),
                lastName: _lastNameController.text.trim(),
                email: _emailController.text.trim(),
                dob: _dobController.text.trim(),
              ),
            );
            if (!mounted) return;
            Navigator.pop(context);
          },
          child: const Text(
            'Save',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
