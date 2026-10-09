import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AppDataTable extends StatefulWidget {
  const AppDataTable({
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.showCheckboxColumn = false,
    this.horizontalMargin,
    this.columnSpacing,
    this.showBottomBorder = true,
    this.headingRowHeight,
    this.dataRowHeight,
    super.key,
  });

  final List<AppDataColumn> columns;
  final List<AppDataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int columnIndex, bool ascending)? onSort;
  final bool showCheckboxColumn;
  final double? horizontalMargin;
  final double? columnSpacing;
  final bool showBottomBorder;
  final double? headingRowHeight;
  final double? dataRowHeight;

  @override
  State<AppDataTable> createState() => _AppDataTableState();
}

class _AppDataTableState extends State<AppDataTable> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: widget.columns.map((col) => DataColumn(
            label: col.label,
            tooltip: col.tooltip,
            numeric: col.numeric,
            onSort: col.onSort ?? (widget.onSort != null 
                ? (columnIndex, ascending) => widget.onSort!(columnIndex, ascending)
                : null),
          )).toList(),
          rows: widget.rows.map((row) => DataRow(
            cells: row.cells.map((cell) => DataCell(
              cell.child,
              showEditIcon: cell.showEditIcon,
              placeholder: cell.placeholder,
              onTap: cell.onTap,
              onLongPress: cell.onLongPress,
              onTapDown: cell.onTapDown,
              onDoubleTap: cell.onDoubleTap,
              onTapCancel: cell.onTapCancel,
            )).toList(),
            selected: row.selected,
            onSelectChanged: row.onSelectChanged,
            color: row.color,
          )).toList(),
          sortColumnIndex: widget.sortColumnIndex,
          sortAscending: widget.sortAscending,
          showCheckboxColumn: widget.showCheckboxColumn,
          horizontalMargin: widget.horizontalMargin ?? AppTheme.spaceMedium,
          columnSpacing: widget.columnSpacing ?? AppTheme.spaceLarge,
          showBottomBorder: widget.showBottomBorder,
          headingRowHeight: widget.headingRowHeight,
          dataRowHeight: widget.dataRowHeight,
        ),
      ),
    );
  }
}

class AppDataColumn {
  const AppDataColumn({
    required this.label,
    this.tooltip,
    this.numeric = false,
    this.onSort,
  });

  final Widget label;
  final String? tooltip;
  final bool numeric;
  final void Function(int columnIndex, bool ascending)? onSort;
}

class AppDataRow {
  const AppDataRow({
    required this.cells,
    this.selected = false,
    this.onSelectChanged,
    this.color,
  });

  final List<AppDataCell> cells;
  final bool selected;
  final ValueChanged<bool?>? onSelectChanged;
  final WidgetStateProperty<Color?>? color;
}

class AppDataCell {
  const AppDataCell({
    required this.child,
    this.showEditIcon = false,
    this.placeholder = false,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.onDoubleTap,
    this.onTapCancel,
  });

  final Widget child;
  final bool showEditIcon;
  final bool placeholder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onTapCancel;
}

// Specialized widgets for common cell types
class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    this.color,
    this.backgroundColor,
    this.size = StatusChipSize.medium,
    super.key,
  });

  final String label;
  final Color? color;
  final Color? backgroundColor;
  final StatusChipSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final chipColor = color ?? theme.colorScheme.primary;
    final bgColor = backgroundColor ?? chipColor.withValues(alpha: 0.1);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == StatusChipSize.small ? 8 : 12,
        vertical: size == StatusChipSize.small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusRounded),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: (size == StatusChipSize.small 
            ? theme.textTheme.labelSmall 
            : theme.textTheme.labelMedium)?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

enum StatusChipSize { small, medium }

class AvatarCell extends StatelessWidget {
  const AvatarCell({
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.size = 40,
    super.key,
  });

  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: theme.colorScheme.primary,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Text(
                  _getInitials(name),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppTheme.spaceSmall),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }
}

class ActionCell extends StatelessWidget {
  const ActionCell({
    required this.actions,
    super.key,
  });

  final List<ActionItem> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) => Padding(
        padding: const EdgeInsets.only(right: AppTheme.spaceXSmall),
        child: IconButton(
          icon: Icon(action.icon),
          onPressed: action.onPressed,
          tooltip: action.tooltip,
          iconSize: 20,
        ),
      )).toList(),
    );
  }
}

class ActionItem {
  const ActionItem({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
}