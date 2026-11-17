import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workforces/features/leaves/data/leave_repository.dart';
import 'package:workforces/features/leaves/domain/leave_models.dart';
import 'package:workforces/core/data/api_client.dart';

// Mock classes
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late LeaveRepository leaveRepository;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    leaveRepository = LeaveRepository(apiClient: mockApiClient);
  });

  group('LeaveRepository', () {
    group('getLeaveBalances', () {
      test('should return list of leave balances on success', () async {
        // Arrange
        final mockResponse = {
          'balances': [
            {
              'id': '1',
              'leave_type': 'annual',
              'total_entitled': 20.0,
              'used': 5.0,
              'pending': 2.0,
              'available': 13.0,
            },
            {
              'id': '2',
              'leave_type': 'sick',
              'total_entitled': 10.0,
              'used': 3.0,
              'pending': 0.0,
              'available': 7.0,
            },
          ],
        };

        when(() => mockApiClient.get('/leaves/balances'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await leaveRepository.getLeaveBalances();

        // Assert
        expect(result.length, 2);
        expect(result[0].leaveType, LeaveType.annual);
        expect(result[0].available, 13.0);
        expect(result[1].leaveType, LeaveType.sick);
        verify(() => mockApiClient.get('/leaves/balances')).called(1);
      });

      test('should return empty list when no balances exist', () async {
        // Arrange
        when(() => mockApiClient.get('/leaves/balances'))
            .thenAnswer((_) async => {'balances': []});

        // Act
        final result = await leaveRepository.getLeaveBalances();

        // Assert
        expect(result, isEmpty);
      });

      test('should throw exception on API error', () async {
        // Arrange
        when(() => mockApiClient.get('/leaves/balances'))
            .thenThrow(Exception('API Error'));

        // Act & Assert
        expect(() => leaveRepository.getLeaveBalances(), throwsException);
      });
    });

    group('submitLeaveRequest', () {
      final testLeaveRequest = LeaveRequest(
        id: 'test-id',
        employeeId: 'emp-123',
        leaveType: LeaveType.annual,
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 20),
        days: 5.0,
        reason: 'Family vacation',
        status: LeaveStatus.pending,
        requestedAt: DateTime.now(),
      );

      test('should submit leave request successfully', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'request_id': 'new-request-id',
          'message': 'Leave request submitted',
        };

        when(() => mockApiClient.post('/leaves/requests', data: any(named: 'data')))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await leaveRepository.submitLeaveRequest(testLeaveRequest);

        // Assert
        expect(result.isSuccess, true);
        expect(result.data, contains('new-request-id'));
        verify(() => mockApiClient.post('/leaves/requests', data: any(named: 'data'))).called(1);
      });

      test('should return failure when validation fails', () async {
        // Arrange
        when(() => mockApiClient.post('/leaves/requests', data: any(named: 'data')))
            .thenThrow(Exception('Insufficient leave balance'));

        // Act
        final result = await leaveRepository.submitLeaveRequest(testLeaveRequest);

        // Assert
        expect(result.isFailure, true);
        expect(result.error, contains('Insufficient leave balance'));
      });
    });

    group('getLeaveRequests', () {
      test('should return list of leave requests', () async {
        // Arrange
        final mockResponse = {
          'requests': [
            {
              'id': 'req-1',
              'employee_id': 'emp-123',
              'leave_type': 'annual',
              'start_date': '2024-01-15',
              'end_date': '2024-01-20',
              'days': 5.0,
              'reason': 'Vacation',
              'status': 'approved',
              'requested_at': DateTime.now().toIso8601String(),
            },
          ],
        };

        when(() => mockApiClient.get('/leaves/requests'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await leaveRepository.getLeaveRequests();

        // Assert
        expect(result.length, 1);
        expect(result[0].status, LeaveStatus.approved);
        expect(result[0].days, 5.0);
      });
    });

    group('cancelLeaveRequest', () {
      const requestId = 'req-123';

      test('should cancel leave request successfully', () async {
        // Arrange
        when(() => mockApiClient.delete('/leaves/requests/$requestId'))
            .thenAnswer((_) async => {'success': true});

        // Act
        final result = await leaveRepository.cancelLeaveRequest(requestId);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockApiClient.delete('/leaves/requests/$requestId')).called(1);
      });

      test('should return failure when cancellation is not allowed', () async {
        // Arrange
        when(() => mockApiClient.delete('/leaves/requests/$requestId'))
            .thenThrow(Exception('Cannot cancel approved leave'));

        // Act
        final result = await leaveRepository.cancelLeaveRequest(requestId);

        // Assert
        expect(result.isFailure, true);
      });
    });
  });
}
