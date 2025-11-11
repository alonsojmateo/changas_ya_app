import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/presentation/components/banner_widget.dart';
import 'dart:io';

class JobForm extends ConsumerStatefulWidget {
  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const JobForm({super.key, required this.onSubmit});

  @override
  ConsumerState<JobForm> createState() => _JobFormState();
}

class _JobFormState extends ConsumerState<JobForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  bool _isLoading = false;
  List<File> _selectedImages = []; // Para futura implementación de imágenes
  String? _selectedOffice; // Para oficios relacionados

  // Lista temporal de oficios - TODO: Mover a provider
  final List<String> _availableOffices = [
    'Plomería',
    'Electricidad',
    'Carpintería',
    'Pintura',
    'Albañilería',
    'Jardinería',
    'Limpieza',
    'Reparaciones generales',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final formWidth = isWeb ? 600.0 : double.infinity;

    final titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return Center(
      child: Container(
        width: formWidth,
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 0 : 20.0,
          vertical: 20.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner igual que otros screens
              Bannerwidget(
                imageAsset: 'lib/images/signup_banner.png',
                titleStyle: titleStyle,
                titleToShow: 'Crear trabajo',
              ),

              const SizedBox(height: 20),

              // Título del trabajo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Título del trabajo',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es requerido';
                    }
                    return null;
                  },
                ),
              ),

              // Input para subir imágenes - Placeholder para futura implementación
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Imágenes del trabajo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Implementar image_picker
                          _showImagePickerDialog();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedImages.isEmpty
                                  ? 'Toca para subir imágenes'
                                  : '${_selectedImages.length} imagen(es) seleccionada(s)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Puedes subir varias imágenes de la reparación',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Descripción del trabajo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descripción del trabajo',
                    hintText:
                        'Describe detalladamente el trabajo a realizar...',
                    prefixIcon: Icon(Icons.description_outlined),
                    helperText: 'Campo obligatorio',
                    helperStyle: TextStyle(color: Colors.red),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es requerida';
                    }
                    if (value.trim().length < 10) {
                      return 'La descripción debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
              ),

              // Oficios relacionados - Dropdown mejorado
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oficios relacionados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Selecciona el oficio necesario',
                        prefixIcon: Icon(Icons.build_outlined),
                      ),
                      value: _selectedOffice,
                      isExpanded: true,
                      items: _availableOffices.map((office) {
                        return DropdownMenuItem<String>(
                          value: office,
                          child: Row(
                            children: [
                              Icon(
                                _getOfficeIcon(office),
                                size: 20,
                                color: Colors.blue[600],
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(office)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOffice = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona un oficio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona el oficio principal que consideras necesario para realizar el trabajo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              // Presupuesto
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Presupuesto disponible',
                    hintText: 'Ingresa tu presupuesto máximo',
                    prefixIcon: Icon(Icons.attach_money),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final budget = double.tryParse(value);
                      if (budget == null || budget <= 0) {
                        return 'Ingresa un presupuesto válido mayor a 0';
                      }
                      if (budget > 1000000) {
                        return 'El presupuesto no puede ser mayor a \$1,000,000';
                      }
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Botón Publicar con estilo mejorado
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.publish, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Publicar trabajo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 20),

              // Notas informativas con mejor diseño
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Al publicar, tu trabajo será visible para todos los profesionales.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getOfficeIcon(String office) {
    switch (office) {
      case 'Plomería':
        return Icons.plumbing;
      case 'Electricidad':
        return Icons.electrical_services;
      case 'Carpintería':
        return Icons.carpenter;
      case 'Pintura':
        return Icons.format_paint;
      case 'Albañilería':
        return Icons.construction;
      case 'Jardinería':
        return Icons.grass;
      case 'Limpieza':
        return Icons.cleaning_services;
      default:
        return Icons.build;
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar imágenes'),
          content: const Text(
            'La funcionalidad de subir imágenes estará disponible próximamente.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final jobData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': 'Buscando profesional',
        'budgetManpower': _budgetController.text.isNotEmpty
            ? double.parse(_budgetController.text)
            : null,
        'imageUrls': [], // Por ahora vacio hasta implementar iel mage_picker
        'relatedOffices': _selectedOffice != null ? [_selectedOffice!] : [],
        'datePosted': DateTime.now(),
      };

      print(' DATOS QUE SE ENVÍAN AL PROVIDER:');
      print(jobData);

      await widget.onSubmit(jobData);

      // Limpiar formulario
      _titleController.clear();
      _descriptionController.clear();
      _budgetController.clear();
      setState(() {
        _selectedOffice = null;
        _selectedImages = [];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
