import 'package:flutter/material.dart';
import 'package:mac_feasts/components/restaurant/restaurant_list.dart';

class RestaurantFilters extends StatelessWidget {
  const RestaurantFilters({super.key, required this.onTimeFilter});

  final void Function(TimeFilter? value) onTimeFilter;

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
            ],
            initialSelection: TimeFilter.now,
            leadingIcon: const Icon(Icons.calendar_month),
            label: const Text('Open'),
            onSelected: (value) => onTimeFilter(value),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Transform.flip(
              flipX: true,
              child: const Icon(Icons.sort),
            ),
          ),
        ],
      ),
    );
  }
}
