import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Aplicación',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                  ),
                  title: Text(
                    'Finanzas Personales',
                  ),
                  subtitle: Text(
                    'Control de ingresos y gastos',
                  ),
                ),

                const Divider(height: 1),

                const ListTile(
                  leading: Icon(
                    Icons.phone_android_outlined,
                  ),
                  title: Text(
                    'Versión',
                  ),
                  trailing: Text(
                    '1.0.0',
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                  ),
                  title: const Text(
                    'Acerca de',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName:
                          'Finanzas Personales',
                      applicationVersion:
                          '1.0.0',
                      applicationIcon:
                          const Icon(
                        Icons
                            .account_balance_wallet,
                        size: 45,
                      ),
                      children: const [
                        Text(
                          'Aplicación móvil para registrar y consultar ingresos y gastos personales.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Datos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.save_outlined,
                  ),
                  title: Text(
                    'Almacenamiento local',
                  ),
                  subtitle: Text(
                    'Tus movimientos se guardan directamente en el dispositivo.',
                  ),
                ),

                Divider(height: 1),

                ListTile(
                  leading: Icon(
                    Icons.lock_outline,
                  ),
                  title: Text(
                    'Privacidad',
                  ),
                  subtitle: Text(
                    'La aplicación no necesita una cuenta para funcionar.',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Proyecto',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.code,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Información técnica',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  _InfoRow(
                    label: 'Tecnología',
                    value: 'Flutter',
                  ),

                  SizedBox(height: 10),

                  _InfoRow(
                    label: 'Plataforma',
                    value: 'Android',
                  ),

                  SizedBox(height: 10),

                  _InfoRow(
                    label: 'Versión',
                    value: '1.0.0',
                  ),

                  SizedBox(height: 10),

                  _InfoRow(
                    label: 'Estado',
                    value: 'Funcional',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Center(
            child: Text(
              'Finanzas Personales • 2026',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}