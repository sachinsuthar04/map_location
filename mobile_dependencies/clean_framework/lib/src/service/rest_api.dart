import 'dart:typed_data';

import 'package:clean_framework/clean_framework.dart';

/// The HTTP methods.
enum RestMethod {
  /// GET method
  get,

  /// POST method
  post,

  /// PUT method
  put,

  /// DELETE method
  delete,

  /// PATCH method
  patch,

  ///DELETE Play Load
  deleteWithPayload
}

/// The content type.
enum RestContentType {
  /// application/json
  json,

  /// text/html
  html,

  /// application/octet-stream
  binary,

  /// text/plain
  text,

  /// unknown
  unknown,
}

/// A skeleton class for making RESTful API calls.
///
/// See [SimpleRestApi].
abstract class RestApi<T extends RestResponse> extends ExternalDependency {
  /// The Uri for the request is built inside ResApi, to give flexibility on
  /// how it is used. The path parameter corresponds to the Uri path, which
  /// doesn't hold the host, port and scheme.
  Future<T> request({
    required RestMethod method,
    required String path,
    required String baseUrl,
    required String siteId,
    Map<String, dynamic> requestBody = const {},
  });

  /// Request for binary data.
  Future<T> requestBinary({
    required RestMethod method,
    required String path,
    Map<String, dynamic> requestBody = const {},
  });

  /// Resolve to [RestResponseType] form status [code].
  RestResponseType getResponseTypeFromCode(int? code) =>
      _responseCodeToRestResponseTypeMap[code] ?? RestResponseType.unknown;
}

/// The response signature for [RestApi].
class RestResponse<T> {
  /// The type of response. See [RestResponseType].
  final RestResponseType type;

  /// The actual content of the response.
  final T content;

  /// The uri to where the request was made.
  final Uri uri;

  /// The content type. See [RestContentType].
  final RestContentType contentType;

  /// The actual content of the response in bodyBytes.
  final Uint8List bodyBytes;

  /// Creates a RestResponse.
  RestResponse({
    this.type = RestResponseType.unknown,
    required this.uri,
    this.contentType = RestContentType.unknown,
    required this.content,
    required this.bodyBytes,
  });
}

///
final Map<String, RestContentType> restContentTypeMap = {
  'application/json; charset=utf-8': RestContentType.json,
  'text/html; charset=utf-8': RestContentType.html,
  'text/plain; charset=utf-8': RestContentType.text,
  'application/octet-stream': RestContentType.binary,
  'application/pdf': RestContentType.binary
};

/// The response type.
enum RestResponseType {
  /// Success
  success,

  // Errors
  /// Time Out
  timeOut,

  /// Bad Request
  badRequest,

  /// 404 Not Found
  notFound,

  /// Conflict
  conflict,

  /// Internal Server Error
  internalServerError,

  /// Unauthorized
  unauthorized,

  /// Unknown
  unknown
}

final _responseCodeToRestResponseTypeMap = {
  200: RestResponseType.success,
  201: RestResponseType.success,
  202: RestResponseType.success,
  204: RestResponseType.success,
  400: RestResponseType.badRequest,
  401: RestResponseType.unauthorized,
  403: RestResponseType.unauthorized,
  404: RestResponseType.notFound,
  409: RestResponseType.conflict,
  500: RestResponseType.internalServerError,
  502: RestResponseType.internalServerError,
};
