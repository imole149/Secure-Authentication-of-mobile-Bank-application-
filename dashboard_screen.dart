import 'package:flutter/material.dart';
import '../models/bank_transaction.dart';
import '../models/bank_user.dart';
import '../services/database_service.dart';
import '../widgets/brightcare_logo.dart';

class DashboardScreen extends StatefulWidget {
  final BankUser user;

  const DashboardScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showPassword = false;
  List<BankTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final records = await DatabaseService.instance.getTransactionsForUser(widget.user.id!);
    setState(() {
      _transactions = records;
      _isLoading = false;
    });
  }

  double get _balance {
    return _transactions.fold(0.0, (sum, item) {
      return sum + (item.isCredit ? item.amount : -item.amount);
    });
  }

  double get _totalCredit {
    return _transactions
        .where((transaction) => transaction.isCredit)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get _totalDebit {
    return _transactions
        .where((transaction) => !transaction.isCredit)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Account Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _DetailRow(label: 'Full Name', value: widget.user.fullName),
                  _DetailRow(label: 'Username', value: widget.user.username),
                  _DetailRow(label: 'Email', value: widget.user.email),
                  _DetailRow(label: 'Phone', value: widget.user.phone),
                  _DetailRow(label: 'Account Name', value: widget.user.accountName),
                  _DetailRow(label: 'Account Number', value: widget.user.accountNumber),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailRow(
                          label: 'Password',
                          value: _showPassword ? widget.user.password : '••••••••',
                          showSeparator: false,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setSheetState(() => _showPassword = !_showPassword);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Keep your details safe. This information is stored locally for this demo.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BrightCareLogo(color: Colors.white, showTagline: false),
        actions: [
          IconButton(
            onPressed: _showProfileSheet,
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.user.fullName
                    .split(' ')
                    .map((part) => part.isNotEmpty ? part[0] : '')
                    .take(2)
                    .join(),
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, ${widget.user.firstName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.user.accountName,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        '\$${_balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SummaryCard(
                            label: 'Credit',
                            amount: _totalCredit,
                            color: Colors.green.shade700,
                          ),
                          _SummaryCard(
                            label: 'Debit',
                            amount: _totalDebit,
                            color: Colors.red.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction History',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Expanded(
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : _transactions.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No transactions yet.',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _transactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction = _transactions[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                                          leading: CircleAvatar(
                                            backgroundColor: transaction.isCredit
                                                ? Colors.green.shade100
                                                : Colors.red.shade100,
                                            child: Icon(
                                              transaction.isCredit
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              color: transaction.isCredit
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700,
                                            ),
                                          ),
                                          title: Text(
                                            transaction.description,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(transaction.category),
                                          trailing: Text(
                                            '${transaction.isCredit ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: transaction.isCredit
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showSeparator;

  const _DetailRow({
    required this.label,
    required this.value,
    this.showSeparator = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 16,
          ),
        ),
        if (showSeparator)
          Divider(
            height: 24,
            color: Colors.grey[300],
          ),
      ],
    );
  }
}
