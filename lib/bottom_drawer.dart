import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'colors.dart';
import 'profile_avatar.dart';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    Key key,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.leading,
    this.trailing,
  }) : super(key: key);

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const roundedTop = BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
    );

    return SizedBox.expand(
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: (draggableNotification) {
          return false;
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.0,
          maxChildSize: 1,
          builder: (context, scrollController) => Material(
            color: theme.bottomSheetTheme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: roundedTop,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: theme.appBarTheme.color,
                  toolbarHeight: 10,
                  expandedHeight: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: roundedTop,
                  ),
                  flexibleSpace: Stack(
                    alignment: AlignmentDirectional.center,
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.appBarTheme.color,
                            borderRadius: roundedTop,
                          ),
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.bottomSheetTheme.backgroundColor,
                            borderRadius: roundedTop,
                          ),
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(
                              color: theme.appBarTheme.color,
                              width: 10,
                            ),
                          ),
                          child: ProfileAvatar(
                            avatar: 'reply/avatars/avatar_1.jpg',
                            radius: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        leading,
                        const SizedBox(height: 8),
                        const Divider(
                          color: ReplyColors.blue200,
                          thickness: 0.25,
                          indent: 18,
                          endIndent: 160,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 18),
                          child: Text(
                            'FOLDERS',
                            style: theme.textTheme.caption.copyWith(
                              color: ReplyColors.white50.withOpacity(0.64),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        trailing,
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
