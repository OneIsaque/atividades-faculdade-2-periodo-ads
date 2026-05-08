import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(const ProjetoCajuApp());
}

const cajuPrimary = Color(0xFFDE6B2A); // tom caju
const cajuBackground = Color(0xFFFFF3EB);

class ProjetoCajuApp extends StatelessWidget {
  const ProjetoCajuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Caju - Desktop',
      theme: ThemeData(
        primaryColor: cajuPrimary,
        scaffoldBackgroundColor: cajuBackground,
        appBarTheme: const AppBarTheme(backgroundColor: cajuPrimary),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: cajuPrimary)),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* ---------- Home ---------- */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final niveis = [
      'Nível 1 - Permissão de câmera',
      'Nível 2 - Movimento Mouse/Teclado',
      'Nível 3 - Detectar Movimento Brusco',
      'Nível 4 - Notificação Local (in-app)',
      'Nível 5 - Controle de Eventos (rate limit)',
      'Nível 6 - Mini Anti-Furto (notificação + vibração simulada + log)',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Projeto Caju')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: niveis.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(niveis[i], style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.chevron_right, color: cajuPrimary),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NivelScreen(nivel: i + 1)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NivelScreen extends StatefulWidget {
  final int nivel;
  const NivelScreen({super.key, required this.nivel});

  @override
  State<NivelScreen> createState() => _NivelScreenState();
}

class _NivelScreenState extends State<NivelScreen> {
  double x = 0, y = 0, z = 0;
  DateTime ultimaNotificacao = DateTime.now().subtract(const Duration(seconds: 11));
  final List<String> eventLog = [];
  bool vibrating = false;
  static const double bruscoThreshold = 50.0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Nível 1: solicitação de permissão de câmera

  Future<void> solicitarPermissaoCameraReal() async {
    try {
      // Verifica status atual
      PermissionStatus status = await Permission.camera.status;
      if (status.isGranted) {
        _showInAppNotification('Permissão de câmera já concedida');
        return;
      }

      // Solicita permissão
      status = await Permission.camera.request();

      if (status.isGranted) {
        _showInAppNotification('Permissão concedida');
      } else if (status.isDenied) {
        _showInAppNotification('Permissão negada');
      } else if (status.isPermanentlyDenied) {
        _showInAppNotification('Permissão permanentemente negada. Abra as configurações para habilitar.');
        // Abre as configurações do app para o usuário (se suportado)
        await openAppSettings();
      } else {
        _showInAppNotification('Status de permissão: ${status.toString()}');
      }
    } catch (e) {
      _showInAppNotification('Erro ao solicitar permissão: $e');
    }
  }

  void _showInAppNotification(String mensagem) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cajuPrimary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /* ---------- Movimento  ---------- */

  void _processMovement(double deltaX, double deltaY) {
    setState(() {
      x += deltaX;
      y += deltaY;
      z = 0;
    });

    if (widget.nivel >= 3 && deltaX.abs() > bruscoThreshold) {
      debugPrint('Movimento brusco detectado (deltaX=${deltaX.toStringAsFixed(1)})');
      if (widget.nivel == 3) {
        _showInAppNotification('Movimento detectado (brusco)!');
      }
      if (widget.nivel >= 4) {
        final now = DateTime.now();
        final diff = now.difference(ultimaNotificacao).inSeconds;
        if (widget.nivel >= 5) {
          if (diff > 10) {
            ultimaNotificacao = now;
            _showInAppNotification('Movimento detectado! (notificação enviada)');
          } else {
            debugPrint('Notificação suprimida (rate limit): $diff s desde a última');
          }
        } else {
          _showInAppNotification('Movimento detectado! (notificação enviada)');
          ultimaNotificacao = now;
        }
      }
      if (widget.nivel == 6) {
        _registerAntiFurtoEvent();
      }
    }
  }

  /* ---------- Anti furto ---------- */

  void _registerAntiFurtoEvent() {
    final now = DateTime.now();
    final entry = 'Anti-furto: movimento em ${now.toLocal().toIso8601String()}';
    setState(() {
      eventLog.insert(0, entry);
      vibrating = true;
    });
    _showInAppNotification('Movimento suspeito! Sistema anti-furto acionado.');
    Timer(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => vibrating = false);
    });
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      double dx = 0, dy = 0;
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) dx = -30;
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) dx = 30;
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) dy = -30;
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) dy = 30;
      if (event.logicalKey == LogicalKeyboardKey.keyA) dx = -30;
      if (event.logicalKey == LogicalKeyboardKey.keyD) dx = 30;
      if (event.logicalKey == LogicalKeyboardKey.keyW) dy = -30;
      if (event.logicalKey == LogicalKeyboardKey.keyS) dy = 30;
      if (dx != 0 || dy != 0) _processMovement(dx, dy);
    }
  }

  Widget _buildControlPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Nível ${widget.nivel}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Arraste dentro do painel ou use as teclas ← → ↑ ↓ (WASD)'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: cajuPrimary),
              onPressed: widget.nivel == 1 ? solicitarPermissaoCameraReal : null,
              child: const Text('Solicitar Permissão Câmera (Nível 1)'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: cajuPrimary),
              onPressed: () {
                setState(() {
                  x = 0;
                  y = 0;
                  eventLog.clear();
                });
                _showInAppNotification('Estado reiniciado');
              },
              child: const Text('Resetar'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSensorPanel() {
    return GestureDetector(
      onPanUpdate: (details) {
        _processMovement(details.delta.dx, details.delta.dy);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 420,
        height: 320,
        decoration: BoxDecoration(
          color: vibrating ? Colors.orange.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cajuPrimary.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(color: cajuPrimary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('X: ${x.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('Y: ${y.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Z: ${z.toStringAsFixed(1)}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 16),
            const Text('Arraste aqui para simular movimento', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventLog() {
    return Container(
      width: 420,
      constraints: const BoxConstraints(maxHeight: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cajuPrimary.withOpacity(0.4)),
      ),
      child: eventLog.isEmpty
          ? const Center(child: Text('Nenhum evento registrado', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              itemCount: eventLog.length,
              itemBuilder: (context, i) => ListTile(
                dense: true,
                title: Text(eventLog[i], style: const TextStyle(fontSize: 13)),
                leading: const Icon(Icons.event, size: 18, color: cajuPrimary),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKey,
      child: Scaffold(
        appBar: AppBar(title: Text('Nível ${widget.nivel} — Tema Caju')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildControlPanel(),
                const SizedBox(height: 18),
                _buildSensorPanel(),
                const SizedBox(height: 18),
                if (widget.nivel >= 6) ...[
                  const Text('Log de eventos (Anti-Furto)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildEventLog(),
                ],
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.music_note, color: cajuPrimary),
                    SizedBox(width: 8),
                    Text('Estética inspirada em "Caju" — minimalista e sensorial'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
