import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:chambaya/features/shifts/presentation/shifts_view_model.dart';

const _blue = Color(0xFF1A3FD8);

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({super.key});

  @override
  State<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final _formKey       = GlobalKey<FormState>();
  final _titleCtrl     = TextEditingController();
  final _categoryCtrl  = TextEditingController();
  final _addressCtrl   = TextEditingController();
  final _districtCtrl  = TextEditingController();
  final _provinceCtrl  = TextEditingController();
  final _deptCtrl      = TextEditingController();
  final _paymentCtrl   = TextEditingController();
  final _descCtrl      = TextEditingController();
  final _skillsCtrl    = TextEditingController();
  final _startCtrl     = TextEditingController();
  final _endCtrl       = TextEditingController();

  bool     _isSaving   = false;
  LatLng   _selectedLatLng = const LatLng(-12.046374, -77.042793);
  bool     _locationSelected = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _categoryCtrl.dispose();
    _addressCtrl.dispose();
    _districtCtrl.dispose();
    _provinceCtrl.dispose();
    _deptCtrl.dispose();
    _paymentCtrl.dispose();
    _descCtrl.dispose();
    _skillsCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    // Pedir permiso de ubicación
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    LatLng initial = _selectedLatLng;

    // Intentar obtener ubicación actual
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      initial = LatLng(pos.latitude, pos.longitude);
    } catch (_) {}

    if (!mounted) return;

    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => _MapPickerPage(initial: initial),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLatLng  = result;
        _locationSelected = true;
      });
      await _reverseGeocode(result);
    }
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _addressCtrl.text  = '${p.street ?? ''}, ${p.name ?? ''}'.trim();
          _districtCtrl.text = p.subLocality ?? p.locality ?? '';
          _provinceCtrl.text = p.locality ?? '';
          _deptCtrl.text     = p.administrativeArea ?? '';
        });
      }
    } catch (_) {}
  }

  Future<void> _pickDateTime(TextEditingController ctrl) async {
    final date = await showDatePicker(
      context:     context,
      initialDate: DateTime.now(),
      firstDate:   DateTime.now(),
      lastDate:    DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context:     context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) return;

    final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    ctrl.text = dt.toIso8601String();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final contractorId = await context.read<ShiftsViewModel>().tokenStorage.getUserId();
    final skills = _skillsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final data = {
      'contractorId':   contractorId ?? '',
      'title':          _titleCtrl.text.trim(),
      'category':       _categoryCtrl.text.trim(),
      'address':        _addressCtrl.text.trim(),
      'district':       _districtCtrl.text.trim(),
      'paymentAmount':  double.tryParse(_paymentCtrl.text.trim()) ?? 0,
      'description':    _descCtrl.text.trim(),
      'requiredSkills': skills,
      'scheduledStart': _startCtrl.text.trim(),
      'scheduledEnd':   _endCtrl.text.trim(),
      'latitude':       _selectedLatLng.latitude,
      'longitude':      _selectedLatLng.longitude,
    };

    try {
      await context.read<ShiftsViewModel>().createJob(data);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Publicar Turno',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Field(ctrl: _titleCtrl,    label: 'Título (ej: Apoyo en almacén)', required: true),
            _Field(ctrl: _categoryCtrl, label: 'Categoría (ej: Limpieza, Carga)', required: true),

            // Ubicación
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Ubicación', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),

            // Botón seleccionar en mapa
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton(
                onPressed: _openMapPicker,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: _locationSelected ? _blue : Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      color: _locationSelected ? _blue : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _locationSelected ? 'Ubicación seleccionada ✓' : 'Seleccionar en el mapa',
                      style: TextStyle(
                        color: _locationSelected ? _blue : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Departamento y Provincia en fila
            Row(
              children: [
                Expanded(child: _Field(ctrl: _deptCtrl,     label: 'Departamento')),
                const SizedBox(width: 12),
                Expanded(child: _Field(ctrl: _provinceCtrl, label: 'Provincia')),
              ],
            ),

            _Field(ctrl: _districtCtrl, label: 'Distrito',                        required: true),
            _Field(ctrl: _addressCtrl,  label: 'Dirección (ej: Av. Larco 345)',    required: true),
            _Field(
              ctrl:        _paymentCtrl,
              label:       'Pago S/',
              required:    true,
              keyboardType: TextInputType.number,
            ),
            _Field(
              ctrl:     _descCtrl,
              label:    'Descripción del puesto',
              required: true,
              maxLines: 3,
            ),
            _Field(
              ctrl:  _skillsCtrl,
              label: 'Habilidades requeridas (separadas por coma)',
            ),

            const SizedBox(height: 8),
            _DateTimeField(
              ctrl:  _startCtrl,
              label: 'Fecha y hora de inicio',
              onTap: () => _pickDateTime(_startCtrl),
            ),
            const SizedBox(height: 8),
            _DateTimeField(
              ctrl:  _endCtrl,
              label: 'Fecha y hora de fin',
              onTap: () => _pickDateTime(_endCtrl),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width:  double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Publicar Turno',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Pantalla del mapa para seleccionar ubicación ──────────────────

class _MapPickerPage extends StatefulWidget {
  final LatLng initial;
  const _MapPickerPage({required this.initial});

  @override
  State<_MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<_MapPickerPage> {
  late LatLng _selected;
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Seleccionar ubicación',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selected,
              initialZoom:   15,
              onTap: (_, latLng) => setState(() => _selected = latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.chambaya',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point:  _selected,
                    width:  40,
                    height: 40,
                    child:  const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),

          // Botón confirmar
          Positioned(
            bottom: 24,
            left:   16,
            right:  16,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Confirmar ubicación',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String                label;
  final bool                  required;
  final int                   maxLines;
  final TextInputType         keyboardType;

  const _Field({
    required this.ctrl,
    required this.label,
    this.required     = false,
    this.maxLines     = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller:   ctrl,
        maxLines:     maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText:  label,
          filled:    true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: _blue),
          ),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null
            : null,
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  final TextEditingController ctrl;
  final String                label;
  final VoidCallback          onTap;

  const _DateTimeField({
    required this.ctrl,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      readOnly:   true,
      onTap:      onTap,
      decoration: InputDecoration(
        hintText:   label,
        filled:     true,
        fillColor:  Colors.white,
        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: _blue),
        ),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Selecciona fecha y hora' : null,
    );
  }
}