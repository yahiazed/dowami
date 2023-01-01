import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

CountryPickerDropdown buildFlag(
    {required String cCode, void Function(Country)? onTap}) {
  return CountryPickerDropdown(
    initialValue: 'SA',
    icon: const Icon(Icons.keyboard_arrow_down_rounded),
    itemBuilder: _buildDropdownItem,
    itemFilter: (c) => ['SA', 'AE', 'EG', 'OM', 'KW', 'QA'].contains(c.isoCode),
    priorityList: [
      CountryPickerUtils.getCountryByIsoCode('SA'),
      CountryPickerUtils.getCountryByIsoCode('AE'),
    ],
    sortComparator: (Country a, Country b) => a.isoCode.compareTo(b.isoCode),
    onValuePicked: onTap ??
        (Country country) {
          print("${country.name}");
          cCode = country.phoneCode;
          print(cCode);
        },
  );
}

Widget _buildDropdownItem(Country country) => Container(
      child: Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Text("+${country.phoneCode}"),
        ],
      ),
    );
