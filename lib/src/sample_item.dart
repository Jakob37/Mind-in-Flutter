class SampleItem {
  final int id;
  final String content;

  const SampleItem(this.id, this.content);

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'content': content,
      };

  factory SampleItem.fromJson(Map<String, dynamic> json) => SampleItem(
        int.parse(json['id']),
        json['content'] as String,
      );
}
