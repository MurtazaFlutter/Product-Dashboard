import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:interview_test/features/product/data/datasources/product_remote_data_source.dart';
import 'package:interview_test/features/product/data/repositories/product_repository_impl.dart';
import 'package:interview_test/features/product/domain/repositories/product_repository.dart';
import 'package:interview_test/features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => ProductBloc(repository: sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton(() => http.Client());
}
