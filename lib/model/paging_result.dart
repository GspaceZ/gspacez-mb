class PagingResult<T> {
  final int totalPages;
  final int number;
  final dynamic content;

  PagingResult({
    required this.totalPages,
    required this.number,
    required this.content,
  });

  factory PagingResult.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PagingResult(
      totalPages: json['totalPages'],
      number: json['number'],
      content: (json['content'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
