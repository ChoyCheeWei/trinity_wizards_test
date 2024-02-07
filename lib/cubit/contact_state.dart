part of 'contact_cubit.dart';

enum ContactStateStatus {
  initial,
  initialized,
  loading,
  loaded,
  loadedContactDetails,
  updated,
  failed,
  created,
  createFailed,
  resetState,
}

class ContactState extends Equatable {
  final List<ContactModel> contacts;
  final ContactModel selectedContact;
  final ContactStateStatus stateStatus;

  const ContactState({
    required this.contacts,
    required this.selectedContact,
    required this.stateStatus,
  });

  factory ContactState.initial() {
    return ContactState(
      contacts: [],
      selectedContact: ContactModel.empty(),
      stateStatus: ContactStateStatus.initial,
    );
  }

  ContactState copyWith({
    List<ContactModel>? contacts,
    ContactModel? selectedContact,
    ContactStateStatus? stateStatus,
  }) {
    return ContactState(
      contacts: contacts ?? this.contacts,
      selectedContact: selectedContact ?? this.selectedContact,
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }

  @override
  List<Object?> get props => [
        contacts,
        selectedContact,
      ];
}
