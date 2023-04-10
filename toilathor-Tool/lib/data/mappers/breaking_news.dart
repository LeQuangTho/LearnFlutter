import 'package:toilathor_tool/data/remote/models/responses/breaking_news_response.dart';
import 'package:toilathor_tool/domain/entities/article_entity.dart';
import 'package:toilathor_tool/domain/entities/source_entity.dart';

extension SourceX on Source {
  SourceEntity toEntity() {
    return SourceEntity(id: id, name: id);
  }
}

extension ArticleX on Article {
  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      source: source?.toEntity(),
      author: author,
      title: title,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      description: description,
      content: content,
    );
  }
}
