import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const CheckinApp());
}

class CheckinApp extends StatelessWidget {
  const CheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Check-in de Evento',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        useMaterial3: true,
      ),
      home: const PaginaCheckin(),
    );
  }
}

class PaginaCheckin extends StatefulWidget {
  const PaginaCheckin({super.key});

  @override
  State<PaginaCheckin> createState() => _PaginaCheckinState();
}

class _PaginaCheckinState extends State<PaginaCheckin> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _conteudoIngresso;
  String? _resultado;
  bool _lendo = false;
  bool _processandoLeitura = false;

  final List<String> _presentes = [];

  void _gerarIngresso() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();

    if (nome.isEmpty) return;

    setState(() {
      _conteudoIngresso = 'CHECKIN|$nome|$email';
      _resultado = null;
    });
  }

  void _abrirLeitor() {
    setState(() {
      _lendo = true;
      _processandoLeitura = false;
    });
  }

  void _cancelarLeitura() {
    setState(() {
      _lendo = false;
      _processandoLeitura = false;
    });
  }

  void _validarCodigo(String? codigo) {
    if (codigo == null) {
      setState(() {
        _resultado = 'QR Code inválido';
      });
      return;
    }

    final partes = codigo.split('|');

    if (partes.length != 3 ||
        partes[0] != 'CHECKIN' ||
        partes[1].trim().isEmpty ||
        partes[2].trim().isEmpty) {
      setState(() {
        _resultado = 'QR Code inválido';
      });
      return;
    }

    final nome = partes[1].trim();
    final jaPresente = _presentes.any(
          (pessoa) => pessoa.toLowerCase() == nome.toLowerCase(),
    );

    setState(() {
      if (jaPresente) {
        _resultado = 'Já fez check-in: $nome';
      } else {
        _presentes.add(nome);
        _resultado = 'Check-in confirmado: $nome';
      }
    });
  }

  Color _corResultado() {
    if (_resultado == null) return Colors.grey;
    if (_resultado!.startsWith('Check-in confirmado')) {
      return Colors.green;
    }
    if (_resultado!.startsWith('Já fez check-in')) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_lendo) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ler ingresso')),
        body: Column(
          children: [
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  if (_processandoLeitura) return;

                  final codigos = capture.barcodes;
                  if (codigos.isEmpty) return;

                  _processandoLeitura = true;
                  final codigo = codigos.first.rawValue;

                  setState(() {
                    _lendo = false;
                  });

                  _validarCodigo(codigo);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Aponte a câmera para o QR Code do ingresso',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FilledButton.icon(
                onPressed: _cancelarLeitura,
                icon: const Icon(Icons.close),
                label: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semana da Computação 2026'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.confirmation_number,
              size: 55,
              color: Color(0xFF6750A4),
            ),
            const SizedBox(height: 8),
            const Text(
              'Seu ingresso',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do participante',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _nomeController.text.trim().isEmpty
                  ? null
                  : _gerarIngresso,
              child: const Text('Gerar ingresso'),
            ),
            if (_conteudoIngresso != null) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.event,
                        size: 42,
                        color: Color(0xFF6750A4),
                      ),
                      const Text(
                        'SEMANA DA COMPUTAÇÃO 2026',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _nomeController.text.trim(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(_emailController.text.trim()),
                      const SizedBox(height: 12),
                      QrImageView(
                        data: _conteudoIngresso!,
                        version: QrVersions.auto,
                        size: 190,
                      ),
                      const Text(
                        'Apresente este QR Code na entrada',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _abrirLeitor,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Ler ingresso'),
            ),
            if (_resultado != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _corResultado().withAlpha(30),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _resultado!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _corResultado(),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'Presentes (${_presentes.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (_presentes.isEmpty)
              const Text('Nenhum participante registrado ainda.')
            else
              ..._presentes.map(
                    (nome) => ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text(nome),
                  dense: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
