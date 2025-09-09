// lib/widgets/cards/certificate_card.dart
import 'package:flutter/material.dart';
import '../../models/certificate.dart';

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  const CertificateCard({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.school, color: Theme.of(context).primaryColor),
        title: Text(certificate.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${certificate.issuingOrganization} • ${certificate.date}'),
        trailing: const Icon(Icons.open_in_new),
        onTap: () {
          // Add logic to open credentialUrl later
        },
      ),
    );
  }
}