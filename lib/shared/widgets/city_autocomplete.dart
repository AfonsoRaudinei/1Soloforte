import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class CityAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool required;
  final String? initialState;
  final Function(String city, String state)? onCitySelected;

  const CityAutocomplete({
    super.key,
    required this.controller,
    this.label = 'Cidade',
    this.hint,
    this.required = false,
    this.initialState,
    this.onCitySelected,
  });

  @override
  State<CityAutocomplete> createState() => _CityAutocompleteState();
}

class _CityAutocompleteState extends State<CityAutocomplete> {
  final Dio _dio = Dio();
  List<CityData> _suggestions = [];
  bool _isLoading = false;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    _selectedState = widget.initialState;
  }

  Future<void> _searchCities(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // API do IBGE para buscar municípios
      final response = await _dio.get(
        'https://servicodados.ibge.gov.br/api/v1/localidades/municipios',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final filtered = data
            .where((item) {
              final nome = item['nome'].toString().toLowerCase();
              final uf = item['microrregiao']['mesorregiao']['UF']['sigla'];
              return nome.contains(query.toLowerCase()) &&
                  (_selectedState == null || uf == _selectedState);
            })
            .take(10)
            .map(
              (item) => CityData(
                name: item['nome'],
                state: item['microrregiao']['mesorregiao']['UF']['sigla'],
                stateFullName:
                    item['microrregiao']['mesorregiao']['UF']['nome'],
              ),
            )
            .toList();

        setState(() {
          _suggestions = filtered;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar cidades: $e');
      setState(() {
        _isLoading = false;
        _suggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<CityData>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<CityData>.empty();
        }
        _searchCities(textEditingValue.text);
        return _suggestions;
      },
      displayStringForOption: (CityData option) => option.name,
      onSelected: (CityData selection) {
        widget.controller.text = selection.name;
        if (widget.onCitySelected != null) {
          widget.onCitySelected!(selection.name, selection.state);
        }
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              validator: widget.required
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return '${widget.label} é obrigatório';
                      }
                      return null;
                    }
                  : null,
              decoration: InputDecoration(
                labelText: widget.label + (widget.required ? ' *' : ''),
                hintText: widget.hint ?? 'Digite o nome da cidade',
                prefixIcon: const Icon(
                  Icons.location_city,
                  color: AppColors.primary,
                ),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                labelStyle: AppTypography.bodyMedium,
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: Colors.grey[400],
                ),
              ),
            );
          },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<CityData> onSelected,
            Iterable<CityData> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 400,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final CityData option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_city,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.name,
                                      style: AppTypography.bodyMedium,
                                    ),
                                    Text(
                                      '${option.stateFullName} (${option.state})',
                                      style: AppTypography.caption.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
    );
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }
}

class CityData {
  final String name;
  final String state;
  final String stateFullName;

  CityData({
    required this.name,
    required this.state,
    required this.stateFullName,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CityData && other.name == name && other.state == state;
  }

  @override
  int get hashCode => name.hashCode ^ state.hashCode;
}
