import 'dart:convert';

import 'package:clean_framework/clean_framework.dart';
import 'package:equatable/equatable.dart';

import 'json_service.dart';

export 'json_parse_helpers.dart';

abstract class EitherService<R extends JsonRequestModel,
S extends JsonResponseModel>
    implements Service<R, S> {
  RestApi _restApi;
  String _path;
  RestMethod _method;
  String _baseUrl;
  String _siteId;

  final String path;
  final String baseUrl;
  String siteId;

  EitherService({required RestMethod method,
    required this.path,
    required this.baseUrl,
    required RestApi restApi,
    this.siteId = ""})
      : assert(path.isNotEmpty),
        _path = path,
        _method = method,
        _restApi = restApi,
        _siteId = siteId,
        _baseUrl = baseUrl;

  @override
  Future<Either<ServiceFailure, S>> request({R? requestModel}) async {
    if (await Locator().connectivity.getConnectivityStatus() ==
        ConnectivityStatus.offline) {
      Locator().logger.debug('JsonService response no connectivity error');
      return Left(NoConnectivityServiceFailure());
    }

    Map<String, dynamic> requestJson = const {};
    if (requestModel != null) {
      requestJson = requestModel.toJson();
      if (!isRequestModelJsonValid(requestJson)) {
        Locator().logger.debug('JsonService response invalid request error');
        return Left(GeneralServiceFailure());
      }
    }

    final response = await _restApi.request(
        method: _method,
        path: _path,
        baseUrl: _baseUrl,
        requestBody: requestJson,
        siteId: _siteId);

    if (response.type == RestResponseType.timeOut) {
      Locator().logger.debug('JsonService response no connectivity error');
      return Left(NoConnectivityServiceFailure());
    }

    S model;
    String? source;
    try {
      source = Utf8Decoder().convert(response.bodyBytes);
      source = source.isNotEmpty
          ? json.decode(source) is Map
          ? source
          : json.encode({"data": source})
          : source;
      final Map<String, dynamic> jsonResponse =
      (source.isEmpty) ? {} : json.decode(source) ?? <String, dynamic>{};
      if (response.type != RestResponseType.success) {
        return Left(onError(
            response.type, jsonResponse, returnStatusCodeType(response.type)));
      }

      model = parseResponse(jsonResponse);
      return Right(model);
    } on Exception catch (e) {
      // Errors should not be handled. The app should fail since it a developer
      // mistake and should be fixed ASAP. Exceptions are not the fault of
      // any developer, so we should log them to help us find quickly on
      // production logs the problem.
      Locator()
          .logger
          .error('JsonService response parse exception', e.toString());

      ///following return statement will execute only when non json response from BE
      return Left(onError(response.type, {"message": source},
          returnStatusCodeType(response.type)));
    }
    return Left(GeneralServiceFailure());
  }

  bool isRequestModelJsonValid(Map<String, dynamic> json) {
    try {
      if (json.isEmpty || _jsonContainsNull(json)) return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  bool _jsonContainsNull(Map<String, dynamic> json) {
    bool containsNull = false;
    List values = json.values.toList();
    for (int i = 0; i < values.length; i++) {
      if (values[i] is Map)
        containsNull = _jsonContainsNull(values[i]);
      else if (values[i] == null) containsNull = true;
      if (containsNull) break;
    }
    return containsNull;
  }

  S parseResponse(Map<String, dynamic> jsonResponse);

  ServiceFailure onError(RestResponseType responseType,
      Map<String, dynamic> jsonResponse, int statusCode) {
    return ServiceFailure(
        responseType: responseType,
        jsonResponse: jsonResponse,
        statusCode: statusCode);
  }
}

class ServiceFailure extends Equatable {
  final RestResponseType? responseType;
  final Map<String, dynamic>? jsonResponse;
  final int? statusCode;

  ServiceFailure({this.responseType, this.jsonResponse, this.statusCode});

  @override
  List<Object?> get props => [];
}

class GeneralServiceFailure extends ServiceFailure {}

class NoConnectivityServiceFailure extends ServiceFailure {}

int returnStatusCodeType(RestResponseType responseType) {
  switch (responseType) {
    case RestResponseType.success:
      return 200;
    case RestResponseType.badRequest:
      return 401;
    case RestResponseType.unauthorized:
      return 403;
    case RestResponseType.notFound:
      return 404;
    case RestResponseType.conflict:
      return 409;
    case RestResponseType.internalServerError:
      return 500;
    case RestResponseType.timeOut:
      break;
    case RestResponseType.unknown:
      break;
  }
  return 999;
}
