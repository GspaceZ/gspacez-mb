class BaseResponseApi {
  final int code;
  final String message;
  final dynamic result;

  BaseResponseApi(
      {required this.code, required this.message, required this.result});

  factory BaseResponseApi.fromJson(Map<String, dynamic> json) {
    return BaseResponseApi(
      code: json['code'],
      message: json['message'],
      result: json['result'],
    );
  }
}
