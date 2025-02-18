class ContactModel {
  List<Contact>? contacts;

  ContactModel({
    this.contacts,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        contacts: json["contacts"] == null
            ? []
            : List<Contact>.from(
                json["contacts"]!.map((x) => Contact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contacts": contacts == null
            ? []
            : List<dynamic>.from(contacts!.map((x) => x.toJson())),
      };
}

class Contact {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? interactionCount;
  DateTime? lastInteracted;

  Contact({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.interactionCount = 0,
    DateTime? lastInteracted,
  }) : lastInteracted = lastInteracted ?? DateTime.now();

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
      };
}
