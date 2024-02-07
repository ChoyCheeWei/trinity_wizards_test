import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:trinity_wizards_test/injector.dart';
import 'package:trinity_wizards_test/models/contact_model.dart';
import 'package:trinity_wizards_test/pages/contact_details/contact_details_page.dart';

import '../../cubit/contact_cubit.dart';

class ContactListingPage extends StatefulWidget {
  const ContactListingPage({super.key});

  @override
  State<ContactListingPage> createState() => _ContactListingPageState();
}

class _ContactListingPageState extends State<ContactListingPage> {
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBarWidget(),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: () async {
        await injector<ContactCubit>().refreshContacts();
        _refreshController.refreshCompleted();
      },
      header: const WaterDropHeader(
        waterDropColor: Color(0xffff8c00),
      ),
      child: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            primary: false,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: state.contacts.length,
            itemBuilder: (context, index) {
              final contact = state.contacts[index];
              return _getContactItemWidget(contact);
            },
          );
        },
      ),
    );
  }

  Widget _getContactItemWidget(ContactModel contact) {
    return InkWell(
      onTap: () async {
        await injector<ContactCubit>().getContactsById(
          contactId: contact.id,
        );
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactDetailsPage(
              contact: injector<ContactCubit>().state.selectedContact,
            ),
          ),
        );
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffff8c00),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${contact.lastName} ${contact.firstName}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _getAppBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey,
          height: 1.0,
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.search,
          color: Color(0xffff8c00),
        ),
        onPressed: () {},
      ),
      title: const Center(
        child: Text(
          'Contacts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.add,
            color: Color(0xffff8c00),
          ),
          onPressed: () {
            // Handle add contact action
          },
        ),
      ],
    );
  }
}
