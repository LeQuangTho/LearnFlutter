import 'package:injectable/injectable.dart';
import 'package:toilathor_tool/data/error_handler.dart';
import 'package:toilathor_tool/data/mappers/breaking_news.dart';
import 'package:toilathor_tool/data/remote/models/requests/breaking_news_request.dart';
import 'package:toilathor_tool/data/remote/sources/breaking_news_remote_source.dart';
import 'package:toilathor_tool/di/di.dart';
import 'package:toilathor_tool/domain/entities/article_entity.dart';
import 'package:toilathor_tool/domain/repositories/breaking_news_repository.dart';

@Injectable(as: BreakingNewsRepository)
class BreakingNewsRepositoryImpl implements BreakingNewsRepository {
  final BreakingNewsRemoteSource breakingNewsRemoteSource;

  BreakingNewsRepositoryImpl(this.breakingNewsRemoteSource);

  @override
  Future<List<ArticleEntity>> getBreakingNewsArticles({
    required String apiKey,
    required String sources,
    required int page,
    required int pageSize,
  }) async {
    try {
      final request = BreakingNewsRequest(
          apiKey: apiKey, sources: sources, page: page, pageSize: pageSize);
      final articleList =
          await breakingNewsRemoteSource.getBreakingNewsArticles(request);
      return articleList.map((a) => a.toEntity()).toList();
    } catch (e) {
      throw getIt<ErrorHandler>().handleError(e);
    }
  }
}
