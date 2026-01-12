import 'package:flutter_test/flutter_test.dart';
import 'package:ung_dung_hoc_tieng_anh/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('Email Validation', () {
      test('Valid email should return null', () {
        expect(Validators.validateEmail('test@example.com'), null);
        expect(Validators.validateEmail('user.name@domain.co.uk'), null);
      });

      test('Empty email should return error', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('Invalid email format should return error', () {
        expect(Validators.validateEmail('invalid'), isNotNull);
        expect(Validators.validateEmail('test@'), isNotNull);
        expect(Validators.validateEmail('@example.com'), isNotNull);
        expect(Validators.validateEmail('test@example'), isNotNull);
      });
    });

    group('Password Validation', () {
      test('Valid password should return null', () {
        expect(Validators.validatePassword('password123'), null);
        expect(Validators.validatePassword('123456'), null);
      });

      test('Empty password should return error', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword(null), isNotNull);
      });

      test('Short password should return error', () {
        expect(Validators.validatePassword('12345'), isNotNull);
        expect(Validators.validatePassword('abc'), isNotNull);
      });
    });

    group('Confirm Password Validation', () {
      test('Matching passwords should return null', () {
        expect(
          Validators.validateConfirmPassword('password123', 'password123'),
          null,
        );
      });

      test('Non-matching passwords should return error', () {
        expect(
          Validators.validateConfirmPassword('password123', 'different'),
          isNotNull,
        );
      });

      test('Empty confirm password should return error', () {
        expect(Validators.validateConfirmPassword('', 'password'), isNotNull);
        expect(Validators.validateConfirmPassword(null, 'password'), isNotNull);
      });
    });

    group('Required Field Validation', () {
      test('Valid input should return null', () {
        expect(Validators.validateRequired('John Doe', 'name'), null);
      });

      test('Empty input should return error', () {
        expect(Validators.validateRequired('', 'name'), isNotNull);
        expect(Validators.validateRequired(null, 'name'), isNotNull);
      });
    });
  });
}

