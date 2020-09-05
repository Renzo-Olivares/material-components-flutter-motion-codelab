import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'colors.dart';
import 'home.dart';
import 'model/email_store.dart';

const _assetsPackage = 'flutter_gallery_assets';
const _iconAssetLocation = 'reply/icons';
const _folderIconAssetLocation = '$_iconAssetLocation/twotone_folder.png';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    Key key,
    this.drawerController,
    this.dropArrowController,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
  }) : super(key: key);

  final AnimationController drawerController;
  final AnimationController dropArrowController;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Material(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 28),
            _BottomDrawerDestinations(
              drawerController: drawerController,
              dropArrowController: dropArrowController,
            ),
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
            const _BottomDrawerFolderSection(),
          ],
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination({
    @required this.name,
    @required this.icon,
    @required this.index,
  })  : assert(name != null),
        assert(icon != null),
        assert(index != null);

  final String name;
  final String icon;
  final int index;
}

class _BottomDrawerDestinations extends StatelessWidget {
  const _BottomDrawerDestinations({
    @required this.drawerController,
    @required this.dropArrowController,
  })  : assert(drawerController != null),
        assert(dropArrowController != null);

  final AnimationController drawerController;
  final AnimationController dropArrowController;

  final destinations = const <_Destination>[
    _Destination(
      name: 'Inbox',
      icon: '$_iconAssetLocation/twotone_inbox.png',
      index: 0,
    ),
    _Destination(
      name: 'Starred',
      icon: '$_iconAssetLocation/twotone_star.png',
      index: 1,
    ),
    _Destination(
      name: 'Sent',
      icon: '$_iconAssetLocation/twotone_send.png',
      index: 2,
    ),
    _Destination(
      name: 'Trash',
      icon: '$_iconAssetLocation/twotone_delete.png',
      index: 3,
    ),
    _Destination(
      name: 'Spam',
      icon: '$_iconAssetLocation/twotone_error.png',
      index: 4,
    ),
    _Destination(
      name: 'Drafts',
      icon: '$_iconAssetLocation/twotone_drafts.png',
      index: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (var destination in destinations)
          InkWell(
            onTap: () {
              _onDestinationSelected(destination.index, destination.name);
              drawerController.reverse();
              dropArrowController.forward();
            },
            child: Selector<EmailStore, String>(
              selector: (context, emailStore) =>
                  emailStore.currentlySelectedInbox,
              builder: (context, currentlySelectedInbox, child) {
                return ListTile(
                  leading: ImageIcon(
                    AssetImage(
                      destination.icon,
                      package: _assetsPackage,
                    ),
                    color: destination.name == currentlySelectedInbox
                        ? theme.colorScheme.secondary
                        : ReplyColors.white50.withOpacity(0.64),
                  ),
                  title: Text(
                    destination.name,
                    style: theme.textTheme.bodyText2.copyWith(
                      color: destination.name == currentlySelectedInbox
                          ? theme.colorScheme.secondary
                          : ReplyColors.white50.withOpacity(0.64),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _onDestinationSelected(int index, String destination) {
    var emailStore = Provider.of<EmailStore>(
      mobileMailNavKey.currentContext,
      listen: false,
    );

    if (emailStore.onMailView) {
      emailStore.currentlySelectedEmailId = -1;
    }

    if (emailStore.currentlySelectedInbox != destination) {
      emailStore.currentlySelectedInbox = destination;
    }
  }
}

class _BottomDrawerFolderSection extends StatelessWidget {
  const _BottomDrawerFolderSection();

  final folders = const <String, String>{
    'Receipts': _folderIconAssetLocation,
    'Pine Elementary': _folderIconAssetLocation,
    'Taxes': _folderIconAssetLocation,
    'Vacation': _folderIconAssetLocation,
    'Mortgage': _folderIconAssetLocation,
    'Freelance': _folderIconAssetLocation,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (var folder in folders.keys)
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: ImageIcon(
                AssetImage(
                  folders[folder],
                  package: _assetsPackage,
                ),
                color: ReplyColors.white50.withOpacity(0.64),
              ),
              title: Text(
                folder,
                style: theme.textTheme.bodyText2.copyWith(
                  color: ReplyColors.white50.withOpacity(0.64),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
