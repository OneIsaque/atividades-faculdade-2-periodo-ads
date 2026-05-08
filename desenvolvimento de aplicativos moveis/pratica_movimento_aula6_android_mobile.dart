import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _NotificationService.initialize();
  runApp(const ProjetoCajuApp());
}

/* ---------- Tema Caju ---------- */
const cajuPrimary = Color(0xFFDE6B2A);
const cajuBackground = Color(0xFFFFF3EB);

/* ---------- Serviço de Notificações ---------- */
class _NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'canal1';
  static const String channelName = 'Canal Principal';

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    // Cria canal (Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: 'Canal principal de notificações',
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _plugin.initialize(initSettings);
  }

  static Future<void> show(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _plugin.show(0, title, body, details);
  }
}

/* ---------- App ---------- */
class ProjetoCajuApp extends StatelessWidget {
  const ProjetoCajuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Caju',
      theme: ThemeData(
        primaryColor: cajuPrimary,
        scaffoldBackgroundColor: cajuBackground,
        appBarTheme: const AppBarTheme(backgroundColor: cajuPrimary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: cajuPrimary),
        ),
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
      'Nível 2 - Acelerômetro',
      'Nível 3 - Detectar Movimento Brusco',
      'Nível 4 - Notificação Local (sistema)',
      'Nível 5 - Controle de Eventos (rate limit)',
      'Nível 6 - Mini Anti-Furto (notificação + vibração + log)',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Projeto Caju')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: niveis.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(niveis[i], style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right, color: Colors.black54),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NivelScreen(nivel: i + 1)),
            ),
          );
        },
      ),
    );
  }
}

/* ---------- Tela de Nível (implementa todos os requisitos) ---------- */
class NivelScreen extends StatefulWidget {
  final int nivel;
  const NivelScreen({super.key, required this.nivel});

  @override
  State<NivelScreen> createState() => _NivelScreenState();
}

class _NivelScreenState extends State<NivelScreen> {
  // Valores do acelerômetro
  double x = 0, y = 0, z = 0;

  // Rate limit (Nível 5)
  DateTime ultimaNotificacao = DateTime.now().subtract(const Duration(seconds: 11));

  // Log (Nível 6)
  final List<String> eventLog = [];

  // Threshold para movimento brusco (em m/s^2 ou valor do sensor)
  static const double thresholdBrusco = 8.0;

  StreamSubscription<AccelerometerEvent>? _accelSub;

  @override
  void initState() {
    super.initState();
    if (widget.nivel >= 2) _startAccelerometer();
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  // Nível 1: solicitar permissão real de câmera e notificação (Android 13+)
  Future<void> solicitarPermissoesReais() async {
    try {
      // Câmera
      PermissionStatus camStatus = await Permission.camera.status;
      if (!camStatus.isGranted) {
        camStatus = await Permission.camera.request();
      }

      // Notificação (Android 13+)
      PermissionStatus notifStatus = await Permission.notification.status;
      if (!notifStatus.isGranted) {
        notifStatus = await Permission.notification.request();
      }

      // Resultado
      if (camStatus.isGranted) {
        _showSnack('Permissão de câmera concedida');
      } else if (camStatus.isPermanentlyDenied) {
        _showSnack('Câmera permanentemente negada. Abra configurações.');
        await openAppSettings();
      } else {
        _showSnack('Permissão de câmera negada');
      }

      if (notifStatus.isGranted) {
        _showSnack('Permissão de notificações concedida');
      } else if (notifStatus.isPermanentlyDenied) {
        _showSnack('Notificações permanentemente negadas. Abra configurações.');
        await openAppSettings();
      } else {
        _showSnack('Permissão de notificações negada');
      }
    } catch (e) {
      _showSnack('Erro ao solicitar permissões: $e');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: cajuPrimary, duration: const Duration(seconds: 3)),
    );
  }

  // Inicia leitura do acelerômetro real
  void _startAccelerometer() {
    _accelSub = accelerometerEvents.listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
      _handleSensorEvent(event);
    });
  }

  // Lógica de detecção e ações (níveis 3-6)
  void _handleSensorEvent(AccelerometerEvent event) {
    // Nível 3: detectar movimento brusco (usando eixo X como no material)
    if (widget.nivel >= 3 && event.x.abs() > thresholdBrusco) {
      // Nível 3: apenas indicar
      if (widget.nivel == 3) {
        _showSnack('Movimento detectado (brusco)!');
      }

      // Nível 4/5: notificação do sistema com rate limit (Nível 5)
      if (widget.nivel >= 4) {
        final now = DateTime.now();
        final diff = now.difference(ultimaNotificacao).inSeconds;
        if (widget.nivel >= 5) {
          if (diff > 10) {
            ultimaNotificacao = now;
            _NotificationService.show('Atenção', 'Movimento detectado!');
          } else {
            // suprime notificação para evitar spam
            debugPrint('Notificação suprimida (rate limit): $diff s desde a última');
          }
        } else {
          // Nível 4 sem rate limit
          _NotificationService.show('Atenção', 'Movimento detectado!');
          ultimaNotificacao = now;
        }
      }

      // Nível 6: anti-furto (notificação + vibração + log)
      if (widget.nivel == 6) {
        _NotificationService.show('Alerta Anti-Furto', 'Movimento suspeito detectado!');
        _vibrateDevice();
        _registerEventLog();
      }
    }
  }

  Future<void> _vibrateDevice() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 600);
    }
  }

  void _registerEventLog() {
    final now = DateTime.now();
    final entry = 'Movimento em ${now.toLocal().toIso8601String()}';
    setState(() {
      eventLog.insert(0, entry);
      if (eventLog.length > 50) eventLog.removeLast();
    });
  }

  Widget _buildControlArea() {
    return Column(
      children: [
        Text('Nível ${widget.nivel}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: widget.nivel == 1 ? solicitarPermissoesReais : null,
          child: const Text('Solicitar Permissões (Nível 1)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              x = 0;
              y = 0;
              z = 0;
              eventLog.clear();
              ultimaNotificacao = DateTime.now().subtract(const Duration(seconds: 11));
            });
            _showSnack('Estado reiniciado');
          },
          child: const Text('Resetar Estado'),
        ),
      ],
    );
  }

  Widget _buildSensorDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cajuPrimary.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          Text('Acelerômetro (valores reais do dispositivo)', style: TextStyle(color: cajuPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text('X: ${x.toStringAsFixed(3)}', style: const TextStyle(fontSize: 18)),
          Text('Y: ${y.toStringAsFixed(3)}', style: const TextStyle(fontSize: 18)),
          Text('Z: ${z.toStringAsFixed(3)}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          Text('Threshold brusco: ${thresholdBrusco.toStringAsFixed(1)} (evento.x > threshold)', style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildEventLog() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cajuPrimary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Log de eventos (Anti-Furto)', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (eventLog.isEmpty)
            const Text('Nenhum evento registrado', style: TextStyle(color: Colors.black54))
          else
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: eventLog.length,
                itemBuilder: (context, i) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.event, size: 18, color: Colors.black54),
                  title: Text(eventLog[i], style: const TextStyle(fontSize: 13)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nível ${widget.nivel} — Tema Caju'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildControlArea(),
              const SizedBox(height: 16),
              _buildSensorDisplay(),
              const SizedBox(height: 16),
              if (widget.nivel >= 6) _buildEventLog(),
              const SizedBox(height: 16),
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
    );
  }
}
