import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/contact_model.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactState.initial()) {
    if (state.stateStatus == ContactStateStatus.initial) {
      getContacts();
    }
  }

  Future<void> getContacts() async {
    emit(state.copyWith(stateStatus: ContactStateStatus.initial));
    String jsonString = await rootBundle.loadString('assets/data.json');
    final decodedJson = json.decode(jsonString);
    emit(
      state.copyWith(
        contacts: ContactModel.fromList(decodedJson),
        stateStatus: ContactStateStatus.initialized,
      ),
    );
  }

  Future<void> getContactsById({required String contactId}) async {
    var contact = state.contacts.firstWhere((element) => element.id == contactId);
    emit(
      state.copyWith(
        selectedContact: contact,
        stateStatus: ContactStateStatus.loadedContactDetails,
      ),
    );
  }

  Future<void> refreshContacts() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    final decodedJson = json.decode(jsonString);
    emit(
      state.copyWith(
        contacts: ContactModel.fromList(decodedJson),
        stateStatus: ContactStateStatus.loaded,
      ),
    );
  }

  Future<void> updateContact({required ContactModel item}) async {
    int index = state.contacts.indexWhere((element) => element.id == item.id);
    state.contacts[index] = item;
    emit(
      state.copyWith(
        stateStatus: ContactStateStatus.updated,
        contacts: state.contacts,
      ),
    );
  }
}
