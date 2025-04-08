import 'package:flutter/material.dart';

class CityAutocompleteSearch extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSelected;
  final VoidCallback onSearch;

  const CityAutocompleteSearch({
    super.key,
    required this.controller,
    required this.onSelected,
    required this.onSearch,
  });

  @override
  State<CityAutocompleteSearch> createState() => _CityAutocompleteSearchState();
}

class _CityAutocompleteSearchState extends State<CityAutocompleteSearch> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  final List<String> _popularCities = [
    'New York',
    'London',
    'Tokyo',
    'Paris',
    'Sydney',
    'Singapore',
    'Dubai',
    'Mumbai',
    'Berlin',
    'Toronto'
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_isFocused && widget.controller.text.isNotEmpty) {
        _filterCities(widget.controller.text);
      }
    });
  }

  void _filterCities(String query) {
    if (query.isEmpty) {
      setState(() => _filteredCities = []);
      return;
    }

    setState(() {
      _filteredCities = _popularCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;
    final hintColor = Theme.of(context).hintColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        hintStyle: TextStyle(color: hintColor),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      onChanged: _filterCities,
                      onSubmitted: (_) => widget.onSearch(),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: widget.onSearch,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search,
                          color: isDarkMode ? Colors.black87 : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isFocused && _filteredCities.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                final city = _filteredCities[index];
                return ListTile(
                  dense: true,
                  title: Text(city),
                  leading: Icon(Icons.location_city, color: primaryColor),
                  onTap: () {
                    widget.onSelected(city);
                    _focusNode.unfocus();
                    setState(() => _filteredCities = []);
                  },
                );
              },
            ),
          ),
        if (_isFocused && widget.controller.text.isEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Popular Cities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _popularCities.take(6).map((city) {
                    return GestureDetector(
                      onTap: () {
                        widget.onSelected(city);
                        _focusNode.unfocus();
                      },
                      child: Chip(
                        backgroundColor: primaryColor.withOpacity(0.2),
                        side: BorderSide.none,
                        label: Text(city),
                        labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}
