import 'package:auto_route/annotations.dart';
import 'package:toilathor_tool/presentation/ui/screens/article_detail/article_detail_screen.dart';
import 'package:toilathor_tool/presentation/ui/screens/breaking_news/breaking_news_screen.dart';

/// The route configuration.
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(page: BreakingNewsScreen, initial: true),
    AutoRoute(page: ArticleDetailScreen),
  ],
)
class $AppRouter {}
