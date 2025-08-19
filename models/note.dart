class Note {
  String id;                     // jedinstveni ID
  String title;                  // naslov beleške
  String content;                // tekst beleške
  List<String>? tags;            // tagovi ili kategorije
  List<String>? attachments;     // ID-ovi crteža ili whiteboard layera
  int version;                   // verzija beleške
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.tags,
    this.attachments,
    this.version = 1,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // helper: update content
  void updateContent(String newContent) {
    content = newContent;
    version += 1;
    updatedAt = DateTime.now();
  }
}
