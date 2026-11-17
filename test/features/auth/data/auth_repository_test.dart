import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workforces/features/auth/data/auth_repository.dart';
import 'package:workforces/features/auth/domain/auth_models.dart';
import 'package:workforces/core/data/api_client.dart';

// Mock classes
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AuthRepository authRepository;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    authRepository = AuthRepository(apiClient: mockApiClient);
  });

  group('AuthRepository', () {
    group('login', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      test('should return User when login is successful', () async {
        // Arrange
        final mockResponse = {
          'token': 'test_token_123',
          'user': {
            'id': '1',
            'email': testEmail,
            'name': 'Test User',
            'role': 'employee',
          },
        };

        when(() => mockApiClient.post('/auth/login', data: any(named: 'data')))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.login(testEmail, testPassword);

        // Assert
        expect(result.isSuccess, true);
        expect(result.data?.email, testEmail);
        expect(result.data?.name, 'Test User');
        verify(() => mockApiClient.post('/auth/login', data: {
              'email': testEmail,
              'password': testPassword,
            })).called(1);
      });

      test('should return failure when credentials are invalid', () async {
        // Arrange
        when(() => mockApiClient.post('/auth/login', data: any(named: 'data')))
            .thenThrow(Exception('Invalid credentials'));

        // Act
        final result = await authRepository.login(testEmail, testPassword);

        // Assert
        expect(result.isFailure, true);
        expect(result.error, isNotNull);
      });

      test('should return failure when network error occurs', () async {
        // Arrange
        when(() => mockApiClient.post('/auth/login', data: any(named: 'data')))
            .thenThrow(Exception('Network error'));

        // Act
        final result = await authRepository.login(testEmail, testPassword);

        // Assert
        expect(result.isFailure, true);
        expect(result.error, contains('Network error'));
      });
    });

    group('verifyOTP', () {
      const testEmail = 'test@example.com';
      const testOtp = '123456';

      test('should return success when OTP is valid', () async {
        // Arrange
        final mockResponse = {
          'verified': true,
          'token': 'verified_token',
        };

        when(() => mockApiClient.post('/auth/verify-otp', data: any(named: 'data')))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.verifyOTP(testEmail, testOtp);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockApiClient.post('/auth/verify-otp', data: {
              'email': testEmail,
              'otp': testOtp,
            })).called(1);
      });

      test('should return failure when OTP is invalid', () async {
        // Arrange
        when(() => mockApiClient.post('/auth/verify-otp', data: any(named: 'data')))
            .thenThrow(Exception('Invalid OTP'));

        // Act
        final result = await authRepository.verifyOTP(testEmail, testOtp);

        // Assert
        expect(result.isFailure, true);
      });
    });

    group('logout', () {
      test('should call logout endpoint successfully', () async {
        // Arrange
        when(() => mockApiClient.post('/auth/logout'))
            .thenAnswer((_) async => {'success': true});

        // Act
        await authRepository.logout();

        // Assert
        verify(() => mockApiClient.post('/auth/logout')).called(1);
      });

      test('should handle logout error gracefully', () async {
        // Arrange
        when(() => mockApiClient.post('/auth/logout'))
            .thenThrow(Exception('Logout failed'));

        // Act & Assert
        expect(() => authRepository.logout(), throwsException);
      });
    });
  });
}
