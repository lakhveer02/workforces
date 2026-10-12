import 'package:flutter/material.dart';
import 'states.dart';

/// Example screen demonstrating how to use the state widgets
/// This showcases proper implementation patterns for loading, empty, and error states
class StateWidgetsExample extends StatefulWidget {
  const StateWidgetsExample({super.key});

  @override
  State<StateWidgetsExample> createState() => _StateWidgetsExampleState();
}

class _StateWidgetsExampleState extends State<StateWidgetsExample> {
  bool isLoading = false;
  bool hasError = false;
  bool isEmpty = true;
  List<String> data = [];

  void _simulateDataFetch() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
      hasError = false;
      isEmpty = false;
      data = ['Item 1', 'Item 2', 'Item 3'];
    });
  }

  void _simulateError() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
      hasError = true;
      isEmpty = true;
      data = [];
    });
  }

  void _clearData() {
    setState(() {
      isLoading = false;
      hasError = false;
      isEmpty = true;
      data = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Widgets Demo'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'loading':
                  _simulateDataFetch();
                  break;
                case 'error':
                  _simulateError();
                  break;
                case 'empty':
                  _clearData();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'loading',
                child: Text('Simulate Loading'),
              ),
              const PopupMenuItem(
                value: 'error',
                child: Text('Simulate Error'),
              ),
              const PopupMenuItem(
                value: 'empty',
                child: Text('Show Empty State'),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading state - show skeleton while data is being fetched
    if (isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const EmployeeCardSkeleton(),
      );
    }

    // Error state - show error with retry option
    if (hasError) {
      return AppErrorState.network(
        onRetry: _simulateDataFetch,
        onSupport: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Support contacted!')),
          );
        },
      );
    }

    // Empty state - show when no data is available
    if (isEmpty || data.isEmpty) {
      return AppEmptyState.noEmployees(
        onActionPressed: _simulateDataFetch,
      );
    }

    // Success state - show actual data
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(data[index]),
            subtitle: Text('Description for ${data[index]}'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}

/// Example of using loading skeleton with custom content
class CustomSkeletonExample extends StatelessWidget {
  const CustomSkeletonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Skeleton')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: AppLoadingSkeleton(
          isLoading: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText(width: 200, height: 24),
              SizedBox(height: 12),
              SkeletonText(width: double.infinity, height: 16, lines: 3),
              SizedBox(height: 20),
              Row(
                children: [
                  SkeletonAvatar(radius: 30),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(width: 120, height: 16),
                        SizedBox(height: 4),
                        SkeletonText(width: 80, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}