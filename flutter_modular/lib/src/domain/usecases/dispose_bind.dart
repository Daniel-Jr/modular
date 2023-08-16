import 'package:modular_core/modular_core.dart';
import 'package:result_dart/result_dart.dart';

import '../services/bind_service.dart';

abstract class DisposeBind {
  Result<bool, ModularError> call<T extends Object>({String? tag});
}

class DisposeBindImpl implements DisposeBind {
  final BindService bindService;

  DisposeBindImpl(this.bindService);

  @override
  Result<bool, ModularError> call<T extends Object>({String? tag}) {
    return bindService.disposeBind<T>(tag: tag);
  }
}
