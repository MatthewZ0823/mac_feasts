import 'package:flutter/material.dart';
import 'package:mac_feasts/components/restaurant/restaurant_list.dart';
import 'package:mac_feasts/utils/constants.dart';

enum SortBy { nameAZ, nameZA, location }

class RestaurantFilters extends StatelessWidget {
  const RestaurantFilters({
    super.key,
    required this.onTimeFilterSelected,
    required this.onSortSelected,
  });

  final void Function(TimeFilter? value) onTimeFilterSelected;
  final void Function(SortBy value) onSortSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Row(
        children: [
          DropdownMenu(
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: TimeFilter.now, label: 'Now'),
              DropdownMenuEntry(value: TimeFilter.anytime, label: 'Anytime'),
              DropdownMenuEntry(
                value: TimeFilter.favorited,
                label: 'Favorited',
              ),
            ],
            initialSelection: defaultTimeFilter,
            leadingIcon: const Icon(Icons.calendar_month),
            label: const Text('Open'),
            onSelected: (value) => onTimeFilterSelected(value),
          ),
          const Spacer(),
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                child: const Text('Name (A-Z)'),
                onPressed: () => onSortSelected(SortBy.nameAZ),
              ),
              MenuItemButton(
                child: const Text('Name (Z-A)'),
                onPressed: () => onSortSelected(SortBy.nameZA),
              ),
              MenuItemButton(
                child: const Text('Location'),
                onPressed: () => onSortSelected(SortBy.location),
              ),
            ],
            style: const MenuStyle(alignment: Alignment.bottomRight),
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: Transform.flip(
                  flipX: true,
                  child: const Icon(Icons.sort),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
