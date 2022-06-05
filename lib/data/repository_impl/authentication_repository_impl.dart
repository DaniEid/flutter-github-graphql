import 'package:flutter_github_graphql/data/data_source/remote/authentication_services.dart';
import 'package:flutter_github_graphql/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationServices authenticationServices;

  AuthenticationRepositoryImpl(this.authenticationServices);
}
