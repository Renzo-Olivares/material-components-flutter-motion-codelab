import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'model/email_store.dart';

class MailViewRouterDelegate extends RouterDelegate<void>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  MailViewRouterDelegate({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    bool _handlePopPage(Route<dynamic> route, dynamic result) {
      return false;
    }

    String currentMailBox =
        Provider.of<EmailStore>(context, listen: false).currentlySelectedInbox;
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        FadeThroughTransitionPageWrapper(
          child: child,
          transitionKey: ValueKey(currentMailBox),
        ),
      ],
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => mobileMailNavKey;

  @override
  Future<bool> popRoute() {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.pop();
      Provider.of<EmailStore>(navigatorKey.currentContext, listen: false)
          .currentlySelectedEmailId = -1;
      return SynchronousFuture<bool>(true);
    }
    return SynchronousFuture<bool>(false);
  }

  @override
  Future<void> setNewRoutePath(void configuration) {
    // should never be called
    throw UnimplementedError();
  }
}

class FadeThroughTransitionPageWrapper extends TransitionBuilderPage {
  FadeThroughTransitionPageWrapper({this.child, this.transitionKey})
      : super(
          key: transitionKey,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeThroughTransition(
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );

  final Widget child;
  final ValueKey transitionKey;
}
