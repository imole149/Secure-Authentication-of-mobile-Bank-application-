import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bank_transaction.dart';
import '../models/bank_user.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Database? _database;

  Future<void> initialize() async {
    if (_database != null) {
      return;
    }
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/brightcare.db';

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        password TEXT NOT NULL,
        accountName TEXT NOT NULL,
        accountNumber TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY(userId) REFERENCES users(id)
      )
    ''');
  }

  Future<BankUser?> getUserByCredentials(String username, String password) async {
    final db = _database;
    if (db == null) return null;

    final results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return BankUser.fromMap(results.first);
  }

  Future<bool> usernameExists(String username) async {
    final db = _database;
    if (db == null) return false;

    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    return results.isNotEmpty;
  }

  Future<BankUser> createUser(BankUser user) async {
    final db = _database;
    if (db == null) {
      throw Exception('Database not initialized');
    }

    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  Future<void> addSampleTransactions(int userId) async {
    final db = _database;
    if (db == null) return;

    final now = DateTime.now();
    final sample = <Map<String, Object?>>[
      {
        'userId': userId,
        'date': now.subtract(Duration(days: 1)).toIso8601String(),
        'description': 'Monthly salary deposit',
        'amount': 3250.00,
        'type': 'credit',
        'category': 'Salary',
      },
      {
        'userId': userId,
        'date': now.subtract(Duration(days: 1)).toIso8601String(),
        'description': 'Electricity bill payment',
        'amount': 120.45,
        'type': 'debit',
        'category': 'Utilities',
      },
      {
        'userId': userId,
        'date': now.subtract(Duration(days: 2)).toIso8601String(),
        'description': 'Grocery store purchase',
        'amount': 84.20,
        'type': 'debit',
        'category': 'Groceries',
      },
      {
        'userId': userId,
        'date': now.subtract(Duration(days: 4)).toIso8601String(),
        'description': 'Cashback reward',
        'amount': 15.00,
        'type': 'credit',
        'category': 'Rewards',
      },
      {
        'userId': userId,
        'date': now.subtract(Duration(days: 5)).toIso8601String(),
        'description': 'Online subscription',
        'amount': 9.99,
        'type': 'debit',
        'category': 'Subscriptions',
      },
    ];

    for (final transaction in sample) {
      await db.insert('transactions', transaction);
    }
  }

  Future<List<BankTransaction>> getTransactionsForUser(int userId) async {
    final db = _database;
    if (db == null) return [];

    final results = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return results.map((map) {
      final amountValue = map['amount'];
      final amount = amountValue is int ? amountValue.toDouble() : amountValue as double;
      return BankTransaction(
        id: map['id'] as int?,
        userId: map['userId'] as int,
        date: map['date'] as String,
        description: map['description'] as String,
        amount: amount,
        type: map['type'] as String,
        category: map['category'] as String,
      );
    }).toList();
  }
}
