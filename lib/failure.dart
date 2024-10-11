import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable implements Exception {
  const Failure();
}

class FailedToConnect extends Failure {
  const FailedToConnect();

  @override
  List<Object?> get props => const [];
}

class ServerError extends Failure {
  const ServerError({required this.reason});

  final String? reason;

  @override
  List<Object?> get props => [reason];
}

class ServerDown extends Failure {
  const ServerDown();

  @override
  List<Object?> get props => const [];
}

class FailedToParseResponse extends Failure {
  const FailedToParseResponse();

  @override
  List<Object?> get props => const [];
}

class UnknownFailure extends Failure {
  const UnknownFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}

extension ToFailure on Object {
  Failure toFailure() => switch (this) {
        Failure _ && final f => f,
        _ => UnknownFailure(this),
      };
}
