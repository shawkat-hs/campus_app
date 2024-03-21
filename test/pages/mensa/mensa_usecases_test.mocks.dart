// Mocks generated by Mockito 5.4.4 from annotations
// in campus_app/test/pages/mensa/mensa_usecases_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:appwrite/appwrite.dart' as _i3;
import 'package:campus_app/core/failures.dart' as _i7;
import 'package:campus_app/pages/mensa/dish_entity.dart' as _i8;
import 'package:campus_app/pages/mensa/mensa_datasource.dart' as _i2;
import 'package:campus_app/pages/mensa/mensa_repository.dart' as _i5;
import 'package:dartz/dartz.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeMensaDataSource_0 extends _i1.SmartFake
    implements _i2.MensaDataSource {
  _FakeMensaDataSource_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClient_1 extends _i1.SmartFake implements _i3.Client {
  _FakeClient_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_2<L, R> extends _i1.SmartFake implements _i4.Either<L, R> {
  _FakeEither_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MensaRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMensaRepository extends _i1.Mock implements _i5.MensaRepository {
  MockMensaRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MensaDataSource get mensaDatasource => (super.noSuchMethod(
        Invocation.getter(#mensaDatasource),
        returnValue: _FakeMensaDataSource_0(
          this,
          Invocation.getter(#mensaDatasource),
        ),
      ) as _i2.MensaDataSource);

  @override
  _i3.Client get awClient => (super.noSuchMethod(
        Invocation.getter(#awClient),
        returnValue: _FakeClient_1(
          this,
          Invocation.getter(#awClient),
        ),
      ) as _i3.Client);

  @override
  _i6.Future<_i4.Either<_i7.Failure, List<_i8.DishEntity>>> getScrappedDishes(
          int? restaurant) =>
      (super.noSuchMethod(
        Invocation.method(
          #getScrappedDishes,
          [restaurant],
        ),
        returnValue:
            _i6.Future<_i4.Either<_i7.Failure, List<_i8.DishEntity>>>.value(
                _FakeEither_2<_i7.Failure, List<_i8.DishEntity>>(
          this,
          Invocation.method(
            #getScrappedDishes,
            [restaurant],
          ),
        )),
      ) as _i6.Future<_i4.Either<_i7.Failure, List<_i8.DishEntity>>>);

  @override
  _i4.Either<_i7.Failure, List<_i8.DishEntity>> getCachedDishes(
          int? restaurant) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCachedDishes,
          [restaurant],
        ),
        returnValue: _FakeEither_2<_i7.Failure, List<_i8.DishEntity>>(
          this,
          Invocation.method(
            #getCachedDishes,
            [restaurant],
          ),
        ),
      ) as _i4.Either<_i7.Failure, List<_i8.DishEntity>>);
}
