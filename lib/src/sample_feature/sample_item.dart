class SampleItem {
  final int id;
  final String content;

  const SampleItem(this.id, this.content);

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
      };

  factory SampleItem.fromJson(Map<String, dynamic> json) => SampleItem(
        json['id'],
        json['content'],
      );
}
