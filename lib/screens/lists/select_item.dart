import 'package:flutter/material.dart';

import '../../widgets/cancel.dart';
import '../../widgets/searchable_list_view.dart';
import '../../widgets/simple_scaffold.dart';

/// A widget for selecting a new [value] from a list of [values].
class SelectItem<T> extends StatelessWidget {
  /// Create an instance.
  const SelectItem({
    required this.values,
    required this.onDone,
    this.value,
    this.actions = const [],
    this.title = 'Select Item',
    this.getSearchString,
    this.getWidget,
    super.key,
  });

  /// The values to select from.
  final List<T> values;

  /// The function to call when a new [value] is selected.
  final ValueChanged<T> onDone;

  /// The current value;
  final T? value;

  /// The title of this widget.
  final String title;

  /// The actions to use for this widget.
  final List<Widget> actions;

  /// The function to use to get a search string from a value in [values].
  final String Function(T value)? getSearchString;

  /// The function to use to get a `title` for the resulting [ListTile]s.
  ///
  /// If this value is `null`, then `toString` will be used.
  final Widget Function(T value)? getWidget;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final children = <SearchableListTile>[];
    final getSearchStringFunction = getSearchString;
    final getWidgetFunction = getWidget;
    for (var i = 0; i < values.length; i++) {
      final item = values[i];
      children.add(
        SearchableListTile(
          searchString: getSearchStringFunction == null
              ? item.toString()
              : getSearchStringFunction(item),
          child: ListTile(
            autofocus: item == value || (value == null && i == 0),
            selected: item == value,
            title: getWidgetFunction == null
                ? Text(item.toString())
                : getWidgetFunction(item),
            onTap: () {
              Navigator.pop(context);
              onDone(
                item,
              );
            },
          ),
        ),
      );
    }
    return Cancel(
      child: SimpleScaffold(
        actions: actions,
        title: title,
        body: SearchableListView(children: children),
      ),
    );
  }
}
