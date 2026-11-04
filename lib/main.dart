import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rdqhqgufqedintjhbacl.supabase.co URLS',

    publishableKey: 'sb_publishable_5Du7JgXY1dsS1ILzchW8hA_bHZVoaCj',
  );

  runApp(const KitBusinessApp());
}

class KitBusinessApp extends StatelessWidget {
  const KitBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kit Business',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22C55E), // Vert moderne
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Gris très clair
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _secteurCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _secteurCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _genererKit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // ICI : Plus tard, on appellera l'Edge Function Supabase.
    // Pour l'instant, on simule un temps de chargement de 2 secondes.
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Le bouton fonctionne ! On connectera l\'IA plus tard.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive : si l'écran est large (PC), on centre avec plus d'espace
            final isDesktop = constraints.maxWidth >= 720;
            
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : 20,
                vertical: 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(isDesktop),
                      const SizedBox(height: 40),
                      _buildForm(),
                      const SizedBox(height: 24),
                      _buildButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Kit Business',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Décris ton business. Reçois instantanément un Livre, des Prompts IA et un Sheet financier personnalisés par l\'Intelligence Artificielle.',
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _secteurCtrl,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Ton secteur d\'activité',
              hintText: 'Ex: Boulangerie à Bamako',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.storefront),
            ),
            validator: (v) => (v == null || v.trim().length < 3) ? 'Décris ton secteur (3+ caractères)' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailCtrl,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Ton adresse email',
              hintText: 'pour recevoir ton kit',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email requis';
              final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim());
              return ok ? null : 'Format d\'email invalide';
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        onPressed: _isLoading ? null : _genererKit,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: _isLoading 
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.rocket_launch),
        label: Text(
          _isLoading ? 'Génération en cours...' : 'Générer mon Kit Business',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}