import '../entities/insight.dart';
import '../entities/transaction.dart';
import '../engines/decision_engine.dart';

class GenerateInsights {
  final DecisionEngine decisionEngine;

  GenerateInsights(this.decisionEngine);

  List<Insight> execute({required List<Transaction> prevTransactions, required List<Transaction> currentTransactions}) {
    return decisionEngine.generateInsights(prevTransactions: prevTransactions, currentTransactions: currentTransactions);
  }
}
