class BaseResponseApi {
  final int code;
  final String? message;
  final dynamic result;

  BaseResponseApi({required this.code, this.message, this.result});

  factory BaseResponseApi.fromJson(Map<String, dynamic> json) {
    return BaseResponseApi(
      code: json['code'],
      message: json['message'],
      result: json['result'],
    );
  }
}
