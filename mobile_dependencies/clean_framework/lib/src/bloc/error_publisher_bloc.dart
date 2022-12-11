import 'package:clean_framework/clean_framework.dart';

abstract class ErrorPublisherBloc extends Bloc {
  static final String noListenersError = r'Response Handler has no listeners';

  final Pipe<PublishedErrorType> errorPipe = Pipe<PublishedErrorType>();

  handleError(PublishedErrorType errorType) {
    if (!errorPipe.hasListeners)
      throw StateError(noListenersError);
    else
      errorPipe.send(errorType);
  }

  @override
  void dispose() {
    errorPipe.dispose();
  }
}

enum PublishedErrorType {
  general,
  noConnectivity,
}
