import 'package:modular_core/modular_core.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/services/bind_service.dart';

class BindServiceImpl extends BindService {
  final AutoInjector injector;

  BindServiceImpl(this.injector);

  @override
  Result<bool, ModularError> disposeBind<T extends Object>({String? tag}) {
    if (tag?.isNotEmpty ?? false) {
      injector.disposeSingletonsByTag(tag!);
      return const Success(true);
    }
    final result = injector.disposeSingleton<T>();
    return Success(result != null);
  }

  @override
  Result<T, ModularError> getBind<T extends Object>({String? tag}) {
    try {
      final result = injector.get<T>(tag: tag);
      return Success(result);
    } on AutoInjectorException catch (e, s) {
      return Failure(BindNotFoundException(e.toString(), s));
    }
  }

  @override
  Result<Unit, ModularError> replaceInstance<T>(T instance, [Type? module]) {
    var tag = module?.toString() ?? '';

    if (tag.isEmpty) {
      tag = injector.tags.firstWhere(
        (innerTag) => injector.isAdded<T>(innerTag),
        orElse: () => '',
      );
    } else {
      tag = injector.isAdded<T>(tag) ? tag : '';
    }

    if (tag.isEmpty) {
      return BindNotFoundException(
        '$T unregistred',
        StackTrace.current,
      ).toFailure();
    }

    injector.replaceInstance<T>(instance, tag);
    return Success.unit();
  }
}
