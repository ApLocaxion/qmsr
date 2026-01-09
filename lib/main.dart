import 'package:flutter/material.dart';

import 'core/theme/theme.dart';

void main() {
  runApp(const QmsrApp());
}

enum ChecklistStatus { unset, yes, no, na }

class ChecklistItemState {
  ChecklistStatus status;
  String notes;

  ChecklistItemState({this.status = ChecklistStatus.unset, this.notes = ''});
}

class ChecklistItem {
  const ChecklistItem({required this.id, required this.text});

  final String id;
  final String text;
}

class ChecklistCategory {
  const ChecklistCategory({required this.title, required this.items});

  final String title;
  final List<ChecklistItem> items;
}

class QmsrApp extends StatelessWidget {
  const QmsrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QMSR  Checklist',
      debugShowCheckedModeBanner: false,
      theme: Themes().darkTheme,
      themeMode: ThemeMode.dark,
      home: const ChecklistScreen(),
    );
  }
}

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final Map<String, ChecklistItemState> _stateById = {};

  late final List<ChecklistCategory> _categories = _buildCategories();

  ChecklistItemState _stateFor(String id) {
    return _stateById.putIfAbsent(id, () => ChecklistItemState());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QMSR Checklist',
          style: TextStyle(
            color: textTheme.colorScheme.onSurface,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Image.asset(
            'assets/LoaXion-logo-old.png',
            height: 88,
            // fit: BoxFit.contain,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'High-level checklist categories (MVP scope)',
                style: TextStyle(
                  color: textTheme.colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Each check supports Yes / No / N/A plus notes for evidence, '
                'links, or follow-up actions.',
                style: TextStyle(
                  color: textTheme.colorScheme.onSurface,
                  // fontSize: 14,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildLegend(),
              const SizedBox(height: 16),
              for (final category in _categories) ...[
                _buildCategoryTile(category),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(2), // 👉 gradient border thickness
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purple, Colors.amber]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12), // 👉 original inner padding
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10), // radius - border thickness
        ),
        child: Row(
          children: [
            _statusChip(ChecklistStatus.yes),
            const SizedBox(width: 8),
            _statusChip(ChecklistStatus.no),
            const SizedBox(width: 8),
            _statusChip(ChecklistStatus.na),
            const SizedBox(width: 8),
            _statusChip(ChecklistStatus.unset),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(ChecklistCategory category) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        title: Text(
          category.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${category.items.length} checks'),
        children: [for (final item in category.items) _buildItemCard(item)],
      ),
    );
  }

  Widget _buildItemCard(ChecklistItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = _stateFor(item.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.text,
            style: const TextStyle(
              color: Color.fromARGB(255, 242, 141, 58),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<ChecklistStatus>(
                value: state.status,
                items: const [
                  DropdownMenuItem(
                    value: ChecklistStatus.unset,
                    child: Text(
                      'Select',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: ChecklistStatus.yes,
                    child: Text('Yes', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: ChecklistStatus.no,
                    child: Text('No', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: ChecklistStatus.na,
                    child: Text('N/A', style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    state.status = value;
                  });
                },
              ),
              _statusChip(state.status),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: ValueKey('notes_${item.id}'),
            initialValue: state.notes,
            onChanged: (value) => state.notes = value,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Evidence, references, or follow-up actions',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.black),
              isDense: true,
              fillColor: Colors.white,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              floatingLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              filled: true,
            ),

            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildTechStackCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested tech stack and rationale',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            'Frontend: Flutter (web + mobile) - reuse your existing Flutter '
            'skills and ship one codebase.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Backend: Node.js + Express (REST) or FastAPI (Python) - fast to '
            'build and iterate for an MVP. Firebase is a faster alternative '
            'with less control.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Database: PostgreSQL - structured data for checklists, audits, '
            'users, and evidence metadata. Pair with S3 or MinIO for uploads.',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _statusChip(ChecklistStatus status) {
    String label;
    switch (status) {
      case ChecklistStatus.yes:
        label = 'Yes';
        break;
      case ChecklistStatus.no:
        label = 'No';
        break;
      case ChecklistStatus.na:
        label = 'N/A';
        break;
      case ChecklistStatus.unset:
        label = 'Unset';
        break;
    }
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  List<ChecklistCategory> _buildCategories() {
    return [
      ChecklistCategory(
        title: 'Management responsibility & QMS scope (ISO 4-5)',
        items: _buildItems('mgmt', [
          'QMS scope and applicability documented',
          'Quality policy approved and communicated',
          'Quality objectives defined and tracked',
          'Organizational chart and responsibilities current',
          'Management representative assigned with authority',
          'Management review schedule and agenda defined',
          'Resource planning covers people, tools, and budget',
          'Regulatory requirements and commitments documented',
          'Quality manual or equivalent QMS overview maintained',
        ]),
      ),
      ChecklistCategory(
        title: 'Risk management (ISO 14971 + ISO 13485 clause 7.1)',
        items: _buildItems('risk', [
          'Risk management plan approved for each product',
          'Risk acceptability criteria defined',
          'Hazard identification and analysis completed',
          'Risk control measures selected and documented',
          'Verification of risk controls performed',
          'Residual risk evaluation documented',
          'Benefit-risk analysis captured where needed',
          'Risk management file maintained and current',
          'Post-production information feeds risk updates',
          'Usability risks assessed',
        ]),
      ),
      ChecklistCategory(
        title: 'Design & development controls',
        items: _buildItems('design', [
          'Design and development plan approved',
          'Design inputs complete and reviewed',
          'Design outputs documented and traceable to inputs',
          'Formal design reviews completed with actions tracked',
          'Design verification evidence recorded',
          'Design validation evidence recorded',
          'Design transfer plan and outputs completed',
          'Design changes controlled and documented',
          'Design history file (DHF) complete',
          'Requirements traceability matrix maintained',
        ]),
      ),
      ChecklistCategory(
        title: 'Document & record control',
        items: _buildItems('docs', [
          'Document control procedure approved',
          'Document approval workflow enforced',
          'Document versioning and change history maintained',
          'Obsolete documents removed from use',
          'Controlled distribution list maintained',
          'Record retention schedule defined',
          'Electronic records access and security controlled',
          'Backups and recovery procedures documented',
          'Master document list current',
          'Personnel trained on document control',
        ]),
      ),
      ChecklistCategory(
        title: 'Supplier / purchasing controls',
        items: _buildItems('supplier', [
          'Supplier evaluation and selection criteria defined',
          'Approved supplier list maintained',
          'Quality agreements or contracts in place',
          'Purchasing data specifies requirements',
          'Incoming inspection criteria defined',
          'Supplier performance monitoring performed',
          'Supplier re-evaluation schedule defined',
          'Controls for critical suppliers documented',
          'Traceability for purchased components ensured',
          'Outsourced processes controlled',
        ]),
      ),
      ChecklistCategory(
        title: 'Production & process controls',
        items: _buildItems('production', [
          'Production procedures documented and approved',
          'Work instructions available at point of use',
          'Process validation requirements defined',
          'Equipment maintenance plans documented',
          'Calibration program implemented',
          'Environmental controls monitored',
          'In-process inspection and acceptance criteria defined',
          'Rework and repair instructions controlled',
          'Production changes reviewed and approved',
          'Device history records complete',
        ]),
      ),
      ChecklistCategory(
        title: 'Sterilization / cleanliness (if applicable)',
        items: _buildItems('sterile', [
          'Sterilization method defined and justified',
          'Sterilization validation completed',
          'Routine sterilization monitoring performed',
          'Bioburden testing or cleanliness limits defined',
          'Packaging integrity testing performed',
          'Load configuration and cycle parameters documented',
          'Sterilant residuals assessed',
          'Cleanroom or controlled area procedures defined',
          'Gowning and hygiene requirements documented',
          'Environmental monitoring results reviewed',
        ]),
      ),
      ChecklistCategory(
        title: 'Product identification & traceability',
        items: _buildItems('trace', [
          'Product identification method defined',
          'UDI assignment and labeling controlled',
          'Lot or batch records maintained',
          'Traceability to components and suppliers maintained',
          'Status identification (accept/reject) in place',
          'Labeling controls and approvals documented',
          'Distribution records maintained',
          'Returned product traceability captured',
          'Software version identification controlled',
          'Unique device history record links established',
        ]),
      ),
      ChecklistCategory(
        title: 'CAPA, nonconforming product, complaints, recall readiness',
        items: _buildItems('capa', [
          'Nonconforming product procedure defined',
          'Segregation and disposition controls in place',
          'CAPA process includes root cause analysis',
          'CAPA effectiveness checks performed',
          'CAPA records include approvals and closure',
          'Complaint intake and triage process defined',
          'Complaint investigations documented',
          'Regulatory reporting criteria defined',
          'Recall or field action procedure documented',
          'Complaint trending performed',
          'Nonconformance and CAPA linkages tracked',
        ]),
      ),
      ChecklistCategory(
        title: 'Postmarket surveillance & vigilance',
        items: _buildItems('pms', [
          'Postmarket surveillance plan documented',
          'Postmarket data sources identified',
          'Trending and signal detection performed',
          'Periodic postmarket review conducted',
          'Vigilance reporting timelines defined',
          'Feedback into risk management documented',
          'Corrective actions triggered from PMS data',
          'Customer feedback and service data captured',
          'Field safety corrective action criteria defined',
          'PMCF or equivalent activities planned (if needed)',
        ]),
      ),
      ChecklistCategory(
        title: 'Internal audits & management review',
        items: _buildItems('audit', [
          'Internal audit schedule documented',
          'Auditors trained and independent',
          'Audit plans and checklists prepared',
          'Audit reports issued with findings',
          'Corrective actions from audits tracked',
          'Management review inputs documented',
          'Management review outputs documented',
          'Action items assigned with due dates',
          'Audit program is risk-based',
          'Audit records retained',
        ]),
      ),
      ChecklistCategory(
        title: 'Training & competence',
        items: _buildItems('training', [
          'Training procedure documented',
          'Role-based training matrix maintained',
          'Onboarding training completed',
          'Competence assessments performed',
          'Training records complete and current',
          'Training for changes documented',
          'Training effectiveness evaluated',
          'Contractor or outsourced training controlled',
          'Annual refresher training planned',
          'Job descriptions define competence requirements',
        ]),
      ),
    ];
  }

  List<ChecklistItem> _buildItems(String prefix, List<String> prompts) {
    return List.generate(
      prompts.length,
      (index) => ChecklistItem(id: '$prefix-$index', text: prompts[index]),
    );
  }
}
