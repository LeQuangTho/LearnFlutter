import 'package:toilathor_tool/data/remote/models/requests/breaking_news_request.dart';
import 'package:toilathor_tool/data/remote/models/responses/breaking_news_response.dart';

abstract class BreakingNewsRemoteSource {
  Future<List<Article>> getBreakingNewsArticles(BreakingNewsRequest request);
}
