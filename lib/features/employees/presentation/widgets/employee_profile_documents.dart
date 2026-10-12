import 'package:flutter/material.dart';
import '../../domain/employee_models.dart';

// Mock document model for demonstration
class EmployeeDocument {
  final String id;
  final String name;
  final String type;
  final String size;
  final DateTime uploadDate;
  final String? description;

  const EmployeeDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.uploadDate,
    this.description,
  });
}

class EmployeeProfileDocuments extends StatelessWidget {
  final Employee employee;

  const EmployeeProfileDocuments({
    super.key,
    required this.employee,
  });

  // Mock documents - in a real app, this would come from the repository
  List<EmployeeDocument> get _mockDocuments => [
    EmployeeDocument(
      id: 'doc_001',
      name: 'Resume_${employee.firstName}_${employee.lastName}.pdf',
      type: 'PDF',
      size: '2.4 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 30)),
      description: 'Employee resume and CV',
    ),
    EmployeeDocument(
      id: 'doc_002',
      name: 'ID_Verification.jpg',
      type: 'Image',
      size: '1.8 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 25)),
      description: 'Government ID verification',
    ),
    EmployeeDocument(
      id: 'doc_003',
      name: 'Employment_Contract.pdf',
      type: 'PDF',
      size: '892 KB',
      uploadDate: DateTime.now().subtract(const Duration(days: 20)),
      description: 'Signed employment contract',
    ),
    EmployeeDocument(
      id: 'doc_004',
      name: 'Educational_Certificates.pdf',
      type: 'PDF',
      size: '3.2 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 15)),
      description: 'Educational qualifications and certificates',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final documents = _mockDocuments;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with upload button
          Row(
            children: [
              Text(
                'Employee Documents',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _showUploadDialog,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Document'),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Manage and view all documents related to ${employee.firstName} ${employee.lastName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Document categories
          _buildDocumentSection(
            context,
            'Personal Documents',
            Icons.person,
            documents.where((doc) => 
              doc.name.toLowerCase().contains('id') || 
              doc.name.toLowerCase().contains('resume')
            ).toList(),
          ),
          
          const SizedBox(height: 16),
          
          _buildDocumentSection(
            context,
            'Employment Documents',
            Icons.work,
            documents.where((doc) => 
              doc.name.toLowerCase().contains('contract') || 
              doc.name.toLowerCase().contains('employment')
            ).toList(),
          ),
          
          const SizedBox(height: 16),
          
          _buildDocumentSection(
            context,
            'Educational Documents',
            Icons.school,
            documents.where((doc) => 
              doc.name.toLowerCase().contains('educational') || 
              doc.name.toLowerCase().contains('certificate')
            ).toList(),
          ),
          
          const SizedBox(height: 16),
          
          _buildDocumentSection(
            context,
            'Other Documents',
            Icons.folder,
            documents.where((doc) => 
              !doc.name.toLowerCase().contains('id') &&
              !doc.name.toLowerCase().contains('resume') &&
              !doc.name.toLowerCase().contains('contract') &&
              !doc.name.toLowerCase().contains('employment') &&
              !doc.name.toLowerCase().contains('educational') &&
              !doc.name.toLowerCase().contains('certificate')
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection(
    BuildContext context,
    String title,
    IconData icon,
    List<EmployeeDocument> documents,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${documents.length} document${documents.length != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            
            if (documents.isEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No documents in this category',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              ...documents.map((document) => _buildDocumentItem(context, document)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, EmployeeDocument document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getDocumentTypeColor(document.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getDocumentIcon(document.type),
            color: _getDocumentTypeColor(document.type),
          ),
        ),
        title: Text(
          document.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document.description != null)
              Text(document.description!),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  document.size,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Uploaded ${_formatUploadDate(document.uploadDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleDocumentAction(context, document, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: ListTile(
                leading: Icon(Icons.visibility),
                title: Text('View'),
              ),
            ),
            const PopupMenuItem(
              value: 'download',
              child: ListTile(
                leading: Icon(Icons.download),
                title: Text('Download'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
        onTap: () => _viewDocument(context, document),
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
      case 'jpg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'image':
      case 'jpg':
      case 'png':
        return Colors.blue;
      case 'doc':
      case 'docx':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  String _formatUploadDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  void _viewDocument(BuildContext context, EmployeeDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document.description != null) ...[
              Text('Description: ${document.description}'),
              const SizedBox(height: 8),
            ],
            Text('Type: ${document.type}'),
            Text('Size: ${document.size}'),
            Text('Uploaded: ${_formatUploadDate(document.uploadDate)}'),
            const SizedBox(height: 16),
            const Text(
              'Document preview would be shown here in a real application.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadDocument(context, document);
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _handleDocumentAction(BuildContext context, EmployeeDocument document, String action) {
    switch (action) {
      case 'view':
        _viewDocument(context, document);
        break;
      case 'download':
        _downloadDocument(context, document);
        break;
      case 'delete':
        _deleteDocument(context, document);
        break;
    }
  }

  void _downloadDocument(BuildContext context, EmployeeDocument document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${document.name}...'),
        action: SnackBarAction(
          label: 'Cancel',
          onPressed: () {},
        ),
      ),
    );
  }

  void _deleteDocument(BuildContext context, EmployeeDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text(
          'Are you sure you want to delete "${document.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${document.name} deleted')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog() {
    // This would show a file picker dialog in a real application
    // For now, we'll just show a placeholder dialog
    // showDialog(
    //   context: context,
    //   builder: (context) => const UploadDocumentDialog(),
    // );
  }
}